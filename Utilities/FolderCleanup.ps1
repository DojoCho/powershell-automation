param(
    [string]$Folder,
    [int]$Days = 30
)

Get-ChildItem $Folder -Recurse |
Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$Days) } |
Remove-Item -Force
