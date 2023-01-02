$IS_RUNNING_SILENT = $args -contains "-SilenceProfile"

echo $IS_RUNNING_SILENT

function CheckIfInstalled($module_name) {
    try {
        Import-Module $module_name -ErrorAction Stop
        Write-Host "Module $module_name is installed" -ForegroundColor Green
    } catch {
        Write-Host "Module $module_name is not installed" -ForegroundColor Red
    }
}

function CheckIfCommandExists($command_name) {
    try {
        Get-Command $command_name -ErrorAction Stop | Out-Null
        Write-Host "Module $command_name is installed" -ForegroundColor Green
    } catch {
        Write-Host "Module $command_name is not installed" -ForegroundColor Red
    }
}

function SetEnvPathForCommand($command_name, $path) {
    $env:Path = $env:Path + ";" + $path
    Write-Host "Added $path to PATH" -ForegroundColor Green
}

SetEnvPathForCommand "nvim" "C:\Program Files\Neovim\bin"
SetEnvPathForCommand "fzf" "$env:USERPROFILE\.fzf"

CheckIfCommandExists "oh-my-posh"
CheckIfCommandExists "nvim"
CheckIfInstalled "posh-git"
CheckIfInstalled "Terminal-Icons"
CheckIfInstalled "PSFzf"

# Load prompt config
$PROMPT_CONFIG = Join-Path './' 'powershell' 'omp.json'
oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG | Invoke-Expression
Write-Host "oh-my-posh config loaded." -ForegroundColor Green

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Write-Host "PSReadLine config loaded." -ForegroundColor Green

# Fzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
Write-Host "PSFzf config loaded." -ForegroundColor Green

# Alias
Set-Alias y yarn
Set-Alias yg 'yarn global'
Set-Alias rm rimraf
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Write-Host "Alias config loaded." -ForegroundColor Green

# Utilities
function gimme ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
Write-Host "Command 'gimme' loaded." -ForegroundColor Green
