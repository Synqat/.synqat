SetEnvPathForCommand "nvim" "C:\Program Files\Neovim\bin"
SetEnvPathForCommand "fzf" "$env:USERPROFILE\.fzf"

$PROMPT_CONFIG = Join-Path './' 'powershell' 'omp.json'
$PROMPT_PROFILE = Join-Path './' 'powershell' 'profile.ps1'

function CheckIfInstalled($module_name) {
    try {
        Import-Module $module_name -ErrorAction Stop
        Write-Host "Module $module_name is installed" -ForegroundColor Green
    } catch {
        Write-Host "Module $module_name is not installed" -ForegroundColor Red
    }
}

function SetEnvPathForCommand($command_name, $path) {
    $env:Path = $env:Path + ";" + $path
    Write-Host "Added $path to PATH" -ForegroundColor Green
}

function TryInstallModule($module_name) {
    try {
        Import-Module $module_name -ErrorAction Stop
        Write-Host "Module $module_name is installed" -ForegroundColor Green
    } catch {
        try {
            Write-Host "Module $module_name is not installed, installing..." -ForegroundColor Yellow
            Install-Module -Name $module_name -Scope CurrentUser -Force
            Write-Host "Module $module_name is installed" -ForegroundColor Green
        } catch {
            Write-Host "Failed to install module $module_name" -ForegroundColor Red
        }
    }
}

function TryInstallNerdFonts() {
    try {
        Write-Host "Installing a Nerd Font..." -ForegroundColor Yellow
        # install a nerd font to be used by powershell and oh-my-posh
        oh-my-posh font install
        Write-Host "Nerd Font is installed" -ForegroundColor Green
    } catch {
        Write-Host "Failed to install a Nerd Font" -ForegroundColor Red
    }
}

function TryInstallOhMyPosh() {
    try {
        oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG | Invoke-Expression
        Write-Host "oh-my-posh is installed" -ForegroundColor Green
    } catch {
        try {
            Write-Host "oh-my-posh is not installed, installing..." -ForegroundColor Yellow
            winget install JanDeDobbeleer.OhMyPosh -s winget
            oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG | Invoke-Expression
            Write-Host "oh-my-posh is installed" -ForegroundColor Green
        } catch {
            Write-Host "Failed to install oh-my-posh" -ForegroundColor Red
        }
    }
}

function TryInstallNeoVim() {
    try {
        Get-Command nvim -ErrorAction Stop | Out-Null
        Write-Host "Module nvim (NeoVim) is installed" -ForegroundColor Green
    } catch {
        Write-Host "Module nvim (NeoVim) is not installed, installing..." -ForegroundColor Yellow
        try {
            winget install neovim
            setx /M path "%path%;C:\Program Files\Neovim\bin\"
            Write-Host "Module nvim (NeoVim) is installed" -ForegroundColor Green
        } catch {
            Write-Host "Failed to install nvim (NeoVim)" -ForegroundColor Red
        }
    }
}

# download fzf binary and add it to PATH
if (!(Test-Path $env:USERPROFILE\.fzf)) {
    Write-Host "Downloading 'fzf' binary..." -ForegroundColor Yellow
    $fzf_url = "https://github.com/junegunn/fzf/releases/download/0.35.1/fzf-0.35.1-windows_amd64.zip"
    $fzf_zip = "$env:USERPROFILE\.fzf.zip"
    $fzf_dir = "$env:USERPROFILE\.fzf"
    $fzf_exe = "$fzf_dir\fzf.exe"
    Invoke-WebRequest -Uri $fzf_url -OutFile $fzf_zip
    Expand-Archive -Path $fzf_zip -DestinationPath $fzf_dir
    Remove-Item $fzf_zip%
    setx /M path "%path%;$fzf_dir"
    Write-Host "'fzf' binary downloaded and added to PATH" -ForegroundColor Green
}

if (!(Test-Path $env:ProgramFiles\Git)) {
    Write-Host "Installing 'git'..." -ForegroundColor Yellow
    winget install -e --id Git.Git
    Write-Host "'git' installed" -ForegroundColor Green
}

TryInstallOhMyPosh
TryInstallNerdFonts
TryInstallNeoVim
TryInstallModule("posh-git")
TryInstallModule("Terminal-Icons")
TryInstallModule("PSFzf")

if (!(Test-Path -Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force
}

Set-Content -Path $PROFILE -Value $(Get-Content -Path $PROMPT_PROFILE)

pwsh.exe