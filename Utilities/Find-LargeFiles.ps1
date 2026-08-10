<#
.SYNOPSIS
Finds files larger than 500 MB.
#>

Get-ChildItem C:\ -Recurse -ErrorAction SilentlyContinue |
Where-Object {
    !$_.PSIsContainer -and $_.Length -gt 500MB
} |
Select-Object FullName,
@{Name="Size(GB)";Expression={[math]::Round($_.Length/1GB,2)}} |
Sort-Object "Size(GB)" -Descending