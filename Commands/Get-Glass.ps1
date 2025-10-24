function Get-Glass {
    <#
    .SYNOPSIS
        Gets invisible content 
    .DESCRIPTION
        There are 16 invisible "variation selector" characters.

        This provides just enough information to encode a byte to an invisible character.

        Thus any series of bytes can be encoded in "glass".

        These selectors sometimes occur in the wild, but are always followed by a visible character.

        If you see two or more invisible characters in a row, you've got shards of glass.

        This script searches for unicode variation selectors in files and packages, and reports where they are found.
    .NOTES
        This unpacks any file it reads as an Open Packaging Convention archive, such as Visual Studio Extensions.
    .LINK
        https://github.com/StartAutomating/Glass        
    .LINK
        https://en.wikipedia.org/wiki/Variation_Selectors_(Unicode_block)
    .LINK
        https://www.koi.ai/blog/glassworm-first-self-propagating-worm-using-invisible-code-hits-openvsx-marketplace
    .LINK
        ConvertFrom-Glass
    .LINK
        ConvertTo-Glass
    #>
    [Alias('Glass')]
    param(
    # Looks for glass in a variety of different inputs
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('InputObject','FilePath','FullName')]
    [PSObject[]]
    $From
    )

    begin {
        # Glass can be identified by two or more invisible bytes.
        # (one invisible byte may be an actual variation selector)
        $glassPattern = @(            
            '[\ufe00-\ufe0f]{2,}'  # Match two or more characters in the selection range
        ) -join ''

        # Make our pattern into a real regex, for a bit of performance boost.
        $glassDetector = [Regex]::new($glassPattern) 

        
        $glassFound = @()
        $ToScan = @()
    }

    process {
        # Keep track of the total amount of content scanned
        $totalArchivePartsScanned = 0 
        $totalFilesScanned = 0    
        
        # Go over each potential file in from
        foreach ($file in $from) {            
            # for actual files
            if ($file -is [IO.FileInfo]) {
                # read it as bytes first
                $fileBytes = Get-Content -Raw -LiteralPath $file.FullName -AsByteStream                    
                try {
                    # and see if it is a package.
                    $filePackage = [IO.Packaging.Package]::Open($fileBytes, 'Open', 'Read')
                    # If it was get its parts.
                    $packageParts = @($filePackage.GetParts())
                    if ($packageParts) {
                        foreach ($part in $packageParts) {
                            # Read eac part as a string
                            $partStream = $part.GetStream()                            
                            $partStreamReader = [IO.StreamReader]::new($partStream)
                            $partText = $partStreamReader.ReadToEnd()
                            # and add them to our list of things to scan 
                            $toScan += [PSCustomObject]@{
                                FilePath = $file.FullName
                                Part = $part.Uri
                                Text = $partText
                            }
                            $partStream.Close()
                        }
                    }
                    $filePackage.Close()
                } catch {
                    # If it was not a package, read it's text
                    $fileText = Get-Content -Raw -LiteralPath $file.FullName
                    # and add it to the list of things to scan.
                    $toScan += [PSCustomObject]@{
                        FilePath = $file.FullName
                        Text = $fileText
                    }                    
                }
                return
            }

            # If the input was a string
            if ($file -is [string]) {
                # see if it's a path
                if (Test-Path $file -ErrorAction Ignore) {
                    # If it was, get the file or directory and look for glass
                    Get-Item -Path $file | 
                        Get-Glass
                } else {
                    # otherwise, look for glass in the text blob
                    $toScan += $file
                }
            }

            if ($file -is [psmoduleinfo]) {
                $file | Split-Path | Get-Item | Get-Glass 
                return
            }
            # If the input was a directory
            if ($file -is [IO.DirectoryInfo]) {
                # look for glass in all of the files (including hidden files)
                Get-ChildItem -Force -Recurse -File -LiteralPath $file.FullName | 
                    Get-Glass
                return
            }
            
        }
    }

    end {

        # at the end of the pipeline, scan all we need to scan.
        $GlassFound = foreach ($in in $ToScan) {
            # If there is no text, skip this object
            if (-not $in.Text) {continue }
            
            # Keep track of ow many parts/files we scan
            if ($in.Part) {
                $totalArchivePartsScanned++
            } else {
                $totalFilesScanned++
            }
            # find any shards.
            $shards = @($glassDetector.Matches($in.Text))
            # If we found any
            if ($shards) {
                # write a warning
                Write-Warning "$($in.FilePath)$(if ($in.Part) { "@$($in.Part)"}) contains glass shards at @ $(
                    foreach ($shard in $shards) {
                        $($shard.Index),'-',$($shard.Index + $shard.Length)
                    })"

                # If we found it in a file
                if ($in.FilePath) {
                    # Get the file
                    $fileAndInfo = 
                        Get-Item -LiteralPath $in.FilePath -Force
                            
                    # add on our shard information
                    $fileAndInfo |
                        Add-Member NoteProperty Shards $shards -Force
                    
                    # and optionally add on the part of the archive
                    if ($in.Part) {
                        $fileAndInfo | 
                            Add-Member NoteProperty Part $in.Part -Force                
                    }

                    # then emit the result.
                    $fileAndInfo
                } else {
                    # If we did not find it in a file, output the shards.
                    $shards
                }                
            }
        }

        # If we scanned anything, output our results
        if ($totalFilesScanned -or $totalArchivePartsScanned) {
            [PSCustomObject]@{
                FilesScanned = $totalFilesScanned
                PartsScanned = $totalArchivePartsScanned 
                GlassFound = $glassFound                
            }
        }

        
    }
}
