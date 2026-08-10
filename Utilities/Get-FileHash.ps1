param(
    [string]$FilePath
)

Get-FileHash $FilePath -Algorithm SHA256
