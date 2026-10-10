<#
.SYNOPSIS
  Verify a downloaded release payload against manifest.json.

.NOTES
  ASCII-only on purpose (Windows PowerShell 5.1 ANSI decoding issue).

.EXAMPLE
  & ./tools/verify.ps1 -Root "C:\Users\me\Downloads\DaFeiYu-Portable" -Manifest ./releases/manifest-portable.json
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$Root,
  [Parameter(Mandatory)][string]$Manifest
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $Root).Path
$m = Get-Content -LiteralPath $Manifest -Raw -Encoding UTF8 | ConvertFrom-Json

Write-Host ("manifest : {0}" -f $m.label)
Write-Host ("generated: {0}" -f $m.generated_at)
Write-Host ("expect   : {0} files / {1} bytes" -f $m.file_count, $m.total_bytes)
Write-Host ('-' * 60)

$ok = 0; $bad = @(); $missing = @()
foreach ($e in $m.files) {
  $p = Join-Path $root $e.path
  if (-not (Test-Path -LiteralPath $p)) { $missing += $e.path; continue }
  $item = Get-Item -LiteralPath $p
  if ($item.Length -ne $e.bytes) {
    $bad += ("{0}  [size mismatch: expected {1}, got {2}]" -f $e.path, $e.bytes, $item.Length)
    continue
  }
  $h = (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash.ToLower()
  if ($h -ne $e.sha256) { $bad += ("{0}  [SHA-256 mismatch]" -f $e.path) } else { $ok++ }
}

Write-Host ("matched: {0} / {1}" -f $ok, $m.file_count)
if ($missing.Count) { Write-Host ("MISSING ({0}):" -f $missing.Count); $missing | ForEach-Object { Write-Host ("  MISSING  {0}" -f $_) } }
if ($bad.Count)     { Write-Host ("DIFFERENT ({0}):" -f $bad.Count); $bad | ForEach-Object { Write-Host ("  DIFF     {0}" -f $_) } }

if ($missing.Count -eq 0 -and $bad.Count -eq 0) {
  Write-Host "`n[PASS] all files match the manifest." -ForegroundColor Green
  exit 0
} else {
  Write-Host "`n[FAIL] missing or mismatched files; download again." -ForegroundColor Red
  exit 1
}
