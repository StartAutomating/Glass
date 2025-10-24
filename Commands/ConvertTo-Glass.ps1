function ConvertTo-Glass 
{
    <#
    .SYNOPSIS
        Converts text to glass
    .DESCRIPTION
        Converts a message to invisible "glass" text
    .NOTES
        For safety reasons, this generates a PowerShell engine event.  
        
        To monitor for this, subscribe to the `ConvertTo-Glass` event.
    .EXAMPLE
        ConvertTo-Glass "This is a glass messsage"
    #>
    [Alias('ToGlass')]
    param()

    $allArgsAndInput = @($input) + $args

    foreach ($arg in $allArgsAndInput) {
        $argBytes = $OutputEncoding.GetBytes("$arg")
        $glassString = [BitConverter]::ToString($argBytes) -replace '-' -replace '[0-9a-f]', {
            $match = $_            
            return [string][char](0xFE00 + ("0x$match" -as [byte]))
        }
        $null = New-Event -SourceIdentifier ConvertTo-Glass -Sender $arg -EventArguments $arg, $glassString        
        $glassString
    }
}
