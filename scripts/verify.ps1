param(
  [switch]$SkipCrossTarget
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceFiles = @(
  Get-ChildItem -LiteralPath $projectRoot -Filter '*.mbt' -File |
    Where-Object { $_.Name -notmatch '(_test|_wbtest)\.mbt$' } |
    ForEach-Object { $_.FullName }
)
$whiteboxFiles = @(
  Get-ChildItem -LiteralPath $projectRoot -Filter '*_wbtest.mbt' -File |
    ForEach-Object { $_.FullName }
)
$moonRoot = Join-Path $env:USERPROFILE '.moon'
$buildDir = Join-Path $projectRoot 'target\manual'
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null

function Confirm-Exit([string]$step) {
  if ($LASTEXITCODE -ne 0) {
    throw "$step failed with exit code $LASTEXITCODE"
  }
}

Push-Location -LiteralPath $projectRoot
try {
  if (-not $SkipCrossTarget) {
    foreach ($target in @('native', 'js', 'wasm', 'wasm-gc')) {
      $bundle = Join-Path $moonRoot "lib\core\_build\$target\release\bundle"
      & moonc check -no-mi -target $target -pkg 'xiaobai718-ab/moondelta' `
        -pkg-type library -std-path $bundle `
        -i "$(Join-Path $bundle 'json\json.mi'):json" `
        -i "$(Join-Path $bundle 'debug\debug.mi'):debug" @sourceFiles
      Confirm-Exit "check $target"
      & moonc check -no-mi -whitebox-test -target $target `
        -pkg 'xiaobai718-ab/moondelta' -pkg-type library -std-path $bundle `
        -i "$(Join-Path $bundle 'json\json.mi'):json" `
        -i "$(Join-Path $bundle 'debug\debug.mi'):debug" @sourceFiles @whiteboxFiles
      Confirm-Exit "check tests $target"
    }
  }

  $bundle = Join-Path $moonRoot 'lib\core\_build\js\release\bundle'
  & moonc build-package -target js -pkg 'xiaobai718-ab/moondelta' `
    -pkg-type library -std-path $bundle `
    -i "$(Join-Path $bundle 'json\json.mi'):json" `
    -i "$(Join-Path $bundle 'debug\debug.mi'):debug" `
    -o 'target/manual/moondelta.core' @sourceFiles
  Confirm-Exit 'build library'

  & moonc build-package -target js -pkg 'xiaobai718-ab/moondelta/cmd/selftest' `
    -pkg-type executable -is-main -std-path $bundle `
    -i 'target/manual/moondelta.mi:lib' `
    -o 'target/manual/selftest.core' 'cmd/selftest/main.mbt'
  Confirm-Exit 'build selftest'

  & moonc link-core -target js -main 'xiaobai718-ab/moondelta/cmd/selftest' `
    -js-format cjs -o 'target/manual/selftest.js' `
    (Join-Path $bundle 'core.core') `
    (Join-Path $bundle 'abort\abort.core') `
    'target/manual/moondelta.core' 'target/manual/selftest.core'
  Confirm-Exit 'link selftest'

  & node 'target/manual/selftest.js'
  Confirm-Exit 'run selftest'

  & moonc build-package -target js -pkg 'xiaobai718-ab/moondelta/cmd/main' `
    -pkg-type executable -is-main -std-path $bundle `
    -i 'target/manual/moondelta.mi:lib' `
    -o 'target/manual/demo.core' 'cmd/main/main.mbt'
  Confirm-Exit 'build example'

  & moonc link-core -target js -main 'xiaobai718-ab/moondelta/cmd/main' `
    -js-format cjs -o 'target/manual/demo.js' `
    (Join-Path $bundle 'core.core') `
    'target/manual/moondelta.core' 'target/manual/demo.core'
  Confirm-Exit 'link example'

  $exampleOutput = & node 'target/manual/demo.js'
  Confirm-Exit 'run example'
  if ($exampleOutput -ne '{"ops":[{"insert":"Hello MoonBit\n"}]}') {
    throw "Unexpected example output: $exampleOutput"
  }
  Write-Output "Example output: $exampleOutput"
} finally {
  Pop-Location
}
