$PROMPT_CONFIG = Join-Path './' 'powershell' 'omp.json'
$PROMPT_PROFILE = Join-Path './' 'powershell' 'profile.ps1'

Write-Host "\n\nRefreshing PowerShell profile..." -ForegroundColor Yellow

if (!(Test-Path -Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force
}

Set-Content -Path $PROFILE -Value $(Get-Content -Path $PROMPT_PROFILE)

Write-Host "PowerShell profile refreshed" -ForegroundColor Green

pwsh.exe

