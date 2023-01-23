$PROMPT_CONFIG = Join-Path './' 'powershell' 'omp.json'
$PROMPT_PROFILE = Join-Path './' 'powershell' 'profile.ps1'

$OMP_PROFILE = Join-Path $PROFILE '..' 'omp.json'

Write-Host ""
Write-Host ""
Write-Host "Refreshing PowerShell profile..." -ForegroundColor Yellow

if (!(Test-Path -Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force
}

Set-Content -Path $PROFILE -Value $(Get-Content -Path $PROMPT_PROFILE)

Write-Host "PowerShell profile refreshed" -ForegroundColor Green
Write-Host ""
Write-Host ""
Write-Host "Refreshing oh-my-posh configuration..." -ForegroundColor Yellow

if (!(Test-Path -Path $OMP_PROFILE)) {
    New-Item -Path $OMP_PROFILE -ItemType File -Force
}

Set-Content -Path $OMP_PROFILE -Value $(Get-Content -Path $PROMPT_CONFIG)

Write-Host "oh-my-posh configuration refreshed" -ForegroundColor Green
Write-Host ""
Write-Host ""

pwsh.exe

