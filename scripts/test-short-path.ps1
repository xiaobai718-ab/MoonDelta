param(
  [ValidateSet('native', 'js')]
  [string[]]$Targets = @('native', 'js')
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$tempRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$testDir = Join-Path $tempRoot ('moondelta-test-' + [guid]::NewGuid().ToString('N'))
$absoluteTestDir = [System.IO.Path]::GetFullPath($testDir)
if (-not $absoluteTestDir.StartsWith(
  $tempRoot.TrimEnd([char[]]@([char]92, [char]47)) + [System.IO.Path]::DirectorySeparatorChar,
  [System.StringComparison]::OrdinalIgnoreCase
)) {
  throw "Temporary test directory is outside the temporary root: $absoluteTestDir"
}

New-Item -ItemType Directory -Path $absoluteTestDir -Force | Out-Null
try {
  $tracked = & git -C $projectRoot ls-files
  if ($LASTEXITCODE -ne 0) {
    throw 'Could not list project files'
  }
  foreach ($relative in $tracked) {
    $source = Join-Path $projectRoot $relative
    $destination = Join-Path $absoluteTestDir $relative
    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force |
      Out-Null
    Copy-Item -LiteralPath $source -Destination $destination -Force
  }
  Push-Location -LiteralPath $absoluteTestDir
  try {
    foreach ($target in $Targets) {
      Write-Output "Running MoonBit tests on $target in temporary workspace"
      & moon test --target $target
      if ($LASTEXITCODE -ne 0) {
        throw "moon test --target $target failed with exit code $LASTEXITCODE"
      }
    }
  } finally {
    Pop-Location
  }
} finally {
  Remove-Item -LiteralPath $absoluteTestDir -Recurse -Force
}
