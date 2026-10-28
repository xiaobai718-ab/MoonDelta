$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$tempRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$workDir = Join-Path $tempRoot ('moondelta-info-' + [guid]::NewGuid().ToString('N'))
$absoluteWorkDir = [System.IO.Path]::GetFullPath($workDir)
if (-not $absoluteWorkDir.StartsWith(
  $tempRoot.TrimEnd([char[]]@([char]92, [char]47)) + [System.IO.Path]::DirectorySeparatorChar,
  [System.StringComparison]::OrdinalIgnoreCase
)) {
  throw "Temporary directory is outside the temporary root: $absoluteWorkDir"
}

New-Item -ItemType Directory -Path $absoluteWorkDir -Force | Out-Null
try {
  $files = & git -C $projectRoot ls-files --cached --others --exclude-standard
  if ($LASTEXITCODE -ne 0) { throw 'Could not list project files' }
  foreach ($relative in $files) {
    $source = Join-Path $projectRoot $relative
    $destination = Join-Path $absoluteWorkDir $relative
    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force |
      Out-Null
    Copy-Item -LiteralPath $source -Destination $destination -Force
  }
  Push-Location -LiteralPath $absoluteWorkDir
  try {
    & moon info --frozen
    if ($LASTEXITCODE -ne 0) { throw "moon info failed with exit code $LASTEXITCODE" }
  } finally {
    Pop-Location
  }
  $generated = Join-Path $absoluteWorkDir 'pkg.generated.mbti'
  if (-not (Test-Path -LiteralPath $generated)) {
    throw 'moon info did not create pkg.generated.mbti'
  }
  Copy-Item -LiteralPath $generated -Destination (Join-Path $projectRoot 'pkg.generated.mbti') -Force
} finally {
  Remove-Item -LiteralPath $absoluteWorkDir -Recurse -Force
}
