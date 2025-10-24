function ConvertFrom-Glass {
    <#
    .SYNOPSIS
        Converts from Glass
    .DESCRIPTION
        Converts from glass encoded strings to plain text
    .NOTES
        For safety reasons, this generates a PowerShell engine event.  
        
        To monitor for this, subscribe to the `ConvertFrom-Glass` event.
    .EXAMPLE
        ConvertTo-Glass "Is it Safe?" |
            ConvertFrom-Glass |
            Where-Object { $_ -eq "Is it Safe?" } |
            ConvertTo-Glass "It's safe.  So safe you wouldn't believe it." |
            ConvertFrom-Glass 
    .LINK
        Get-Glass
    .LINK
        ConvertTo-Glass
    #>
    [Alias('FromGlass')]
    param()
    $allArgsAndInput = @($input) + $args

    $glassPattern = @(
        '[\s\r\n\t]{0,}'    # Allow leading whitespace
        '[\ufe00-\ufe0f]+'  # Match any unicode character in the selection range
        '[\s\r\n\t]{0,}'    # Allow all trailing whitespace
    ) -join ''

    $glassDetector = [Regex]::new($glassPattern) 


    foreach ($arg in $allArgsAndInput) {        
        "$arg" -replace $glassDetector, {
            $match = $_
            
            $hex = foreach ($char in "$match".ToCharArray()) {
                "{0:x}" -f (
                    ($char -as [int]) - 0xFE00
                )
            }

            $glassString = $outputEncoding.GetString([Convert]::FromHexString($hex -join ''))
            $null = New-Event -SourceIdentifier "ConvertFrom-Glass" -Sender $arg -EventArguments $match, $glassString 
            $glassString
        }                
    }
}
