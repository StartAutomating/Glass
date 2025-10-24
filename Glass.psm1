$CommandsPath = Join-Path $PSScriptRoot 'Commands'
foreach ($file in Get-ChildItem -Path $CommandsPath -Filter '*-*.ps1') {
    if ($file.Name -like '*.*.ps1') {
        continue
    }
    . $file.FullName
}

if (-not ('IO.Packaging.Package' -as [type])) {
    $addedTypes = Add-type -AssemblyName System.IO.Packaging -PassThru
    $packageTypeFound = $addedTypes | Where-Object FullName -eq 'System.IO.Packaging.Package'
    if (-not $packageTypeFound) {
        Write-Warning "Could not find [IO.Packaging.Package]"
    }
}