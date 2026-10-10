<#
.SYNOPSIS
  Pre-commit guard: scan the repo for forbidden files and credential patterns.

.DESCRIPTION
  This is a last line of defence against slips. Finding nothing here does NOT
  prove there are no secrets; the real guarantee is the path-level .gitignore.

.NOTES
  ASCII-only on purpose (Windows PowerShell 5.1 ANSI decoding issue).

.EXAMPLE
  & ./tools/secret-scan.ps1 -Root .
#>
[CmdletBinding()]
param(
  [string]$Root = '.',
  [string]$Pattern = 'sk-[A-Za-z0-9]{16,}|api[_-]?key\s*[":=]\s*[A-Za-z0-9_\-]{12,}|Bearer\s+[A-Za-z0-9_\-\.]{20,}|AKIA[0-9A-Z]{12,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY-----'
)

$ErrorActionPreference = 'Stop'
$rootPath = (Resolve-Path -LiteralPath $Root).Path
Write-Host ("scan root: {0}" -f $rootPath)

# 1) forbidden file names / paths
$forbiddenNames = @('desktop_pet_api_key.bin','desktop_pet_platform_token.bin',
                    '*.bin','*.db','*.db-shm','*.db-wal','*.log','*.credentials.yaml','.env')
$hitFiles = Get-ChildItem -LiteralPath $rootPath -Force -Recurse -File -ErrorAction SilentlyContinue |
  Where-Object {
    $n = $_.Name
    $nameHit = ($forbiddenNames | Where-Object { $n -like $_ }).Count -gt 0
    $pathHit = $_.FullName -match '\\memory\\|\\tool-output\\'
    $nameHit -or $pathHit
  }

# 2) text content scan (skip binaries and large files)
$hitText = @()
Get-ChildItem -LiteralPath $rootPath -Force -Recurse -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Length -lt 2MB -and $_.Extension -match '^\.(md|txt|json|jsonc|yml|yaml|ps1|cmd|bat|js|ts|py|html|css|gitignore)$' } |
  ForEach-Object {
    $ms = Select-String -LiteralPath $_.FullName -Pattern $Pattern -AllMatches -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($ms) {
      $hitText += [pscustomobject]@{
        file  = $_.FullName.Substring($rootPath.Length).TrimStart('\')
        lines = @($ms).Count
      }
    }
  }

if ($hitFiles) {
  Write-Host "`n[FAIL] forbidden files present in repo (must never be committed):" -ForegroundColor Red
  $hitFiles | ForEach-Object { Write-Host ("  {0}  ({1} B)" -f $_.FullName.Substring($rootPath.Length).TrimStart('\'), $_.Length) }
}
if ($hitText) {
  Write-Host "`n[WARN] suspected credential patterns found in text:" -ForegroundColor Yellow
  $hitText | ForEach-Object { Write-Host ("  {0}  ({1} matching lines)" -f $_.file, $_.lines) }
}

if (-not $hitFiles -and -not $hitText) {
  Write-Host "`n[PASS] no forbidden files, no suspected credential patterns." -ForegroundColor Green
  exit 0
}
exit 1
