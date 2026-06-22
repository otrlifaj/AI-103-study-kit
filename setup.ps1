<#
.SYNOPSIS
    AI-103 study kit — bootstrap závislostí a submodulů.
.DESCRIPTION
    Idempotentní: vytvoří root .venv (Python 3.13), nainstaluje base requirements.txt,
    inicializuje git submoduly (laby) a připomene `az login`.
    Spusť z rootu repa:  ./setup.ps1
    Pak (interaktivní část — Azure config + datovaný studijní plán) spusť skill /setup.
#>
[CmdletBinding()]
param(
    [string]$PythonVersion = "3.13"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

function Write-Step($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }

# 1. Ověř Python 3.13 (laby nejedou na 3.14 — chybí wheels)
Write-Step "Kontrola Pythonu $PythonVersion"
$pyOk = $false
try {
    $v = & py "-$PythonVersion" --version 2>$null
    if ($LASTEXITCODE -eq 0) { Write-Host "Nalezeno: $v"; $pyOk = $true }
} catch {}
if (-not $pyOk) {
    Write-Warning "Python $PythonVersion nenalezen přes 'py -$PythonVersion'. Nainstaluj ho z python.org a spusť znovu."
    Write-Host "Ověř dostupné verze:  py -0p"
    exit 1
}

# 2. Root .venv
Write-Step "Virtuální prostředí (.venv)"
if (-not (Test-Path "$repoRoot\.venv\Scripts\python.exe")) {
    & py "-$PythonVersion" -m venv .venv
    Write-Host "Vytvořeno .venv (Python $PythonVersion)."
} else {
    Write-Host ".venv už existuje — přeskakuji."
}
$venvPy = "$repoRoot\.venv\Scripts\python.exe"

# 3. Závislosti
Write-Step "Instalace závislostí (requirements.txt)"
& $venvPy -m pip install --upgrade pip
& $venvPy -m pip install -r requirements.txt

# 4. Git submoduly (laby)
Write-Step "Inicializace lab submodulů (labs/)"
git submodule update --init --recursive

# 5. Hotovo + další kroky
Write-Step "Hotovo"
Write-Host "Dál:" -ForegroundColor Green
Write-Host "  1) az login            # keyless přihlášení k Azure (DefaultAzureCredential)"
Write-Host "  2) /setup              # skill: vyplní azure-config.md + vygeneruje datovaný studijní plán"
Write-Host "  3) /next-module        # první studijní session"
Write-Host "`nVS Code interpreter:  $venvPy"
