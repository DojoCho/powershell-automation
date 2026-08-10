$tempFolders = @(
    "$env:TEMP",
    "C:\Windows\Temp"
)

foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        Get-ChildItem $folder -Recurse -Force -ErrorAction SilentlyContinue |
        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    }
}

Write-Host "Temporary files removed successfully."
