<#
.SYNOPSIS
  Generate a SHA-256 manifest for a release payload.

.DESCRIPTION
  Records path / size / SHA-256 / mtime only. It does NOT copy or read file
  contents. Credential files and personal-data directories are excluded by
  default and the exclusions are listed in the manifest for auditability.

.NOTES
  ASCII-only on purpose: Windows PowerShell 5.1 mis-decodes BOM-less UTF-8
  script files as ANSI, which corrupts non-ASCII string literals.

.EXAMPLE
  & ./tools/make-manifest.ps1 -Label "DesktopPet v1.18.37" -Source "C:\path\to\build" -Out ./releases/manifest-v1.18.37.json
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$Label,
  [Parameter(Mandatory)][string]$Source,
  [Parameter(Mandatory)][string]$Out,
  [string[]]$ExcludePattern = @(
    '\.bin$', '\.key$', '\.pem$', '\.pfx$', '\.p12$',
    '\.db$', '\.db-shm$', '\.db-wal$',
    '\.log$',
    '\.credentials\.yaml$', '\.env$'
  ),
  # Exclude whole directories (leading, trailing or embedded) that hold
  # user data rather than product files. `\state\` and `\cache\` are included
  # on purpose: agent\state\opencode\prompt-history.jsonl is literally the
  # user's own prompt history and must never be published.
  [string[]]$ExcludePathPattern = @(
    '(^|\\)(memory|data|temp|tmp|state|cache|logs?|locks|tool-output)(\\|$)'
  )
)

$ErrorActionPreference = 'Stop'
$src = (Resolve-Path -LiteralPath $Source).Path

$all = Get-ChildItem -LiteralPath $src -Force -Recurse -File -ErrorAction SilentlyContinue

$excluded = @()
$kept = @()
foreach ($f in $all) {
  $rel = $f.FullName.Substring($src.Length).TrimStart('\')
  $nameHit = $false
  foreach ($p in $ExcludePattern) { if ($f.Name -match $p) { $nameHit = $true; break } }
  $pathHit = $false
  foreach ($p in $ExcludePathPattern) { if ($rel -match $p) { $pathHit = $true; break } }
  if ($nameHit -or $pathHit) {
    $excluded += [pscustomobject]@{
      path   = $rel
      bytes  = $f.Length
      reason = $(if ($nameHit) { 'name-pattern' } else { 'path-pattern' })
    }
  } else {
    $kept += $f
  }
}

Write-Host ("[{0}] hashing {1} files, excluding {2}" -f $Label, $kept.Count, $excluded.Count)

$entries = foreach ($f in $kept) {
  $rel = $f.FullName.Substring($src.Length).TrimStart('\')
  [pscustomobject]@{
    path   = $rel
    bytes  = $f.Length
    sha256 = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash.ToLower()
    mtime  = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
  }
}

$manifest = [pscustomobject]@{
  label          = $Label
  generated_at   = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
  generated_by   = 'tools/make-manifest.ps1'
  source_note    = 'metadata and hashes only; file contents were not copied'
  file_count     = @($entries).Count
  total_bytes    = (@($entries) | Measure-Object -Property bytes -Sum).Sum
  excluded_count = $excluded.Count
  excluded       = $excluded
  files          = @($entries)
}

$outDir = Split-Path -Parent $Out
if ($outDir -and -not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

$manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $Out -Encoding UTF8
Write-Host ("[{0}] wrote {1} ({2} files / {3} bytes / {4} excluded)" -f $Label, $Out, $manifest.file_count, $manifest.total_bytes, $manifest.excluded_count)
