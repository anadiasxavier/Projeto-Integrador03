# Executa o app no Chrome apos liberar a pasta build (evita erro
# "Flutter failed to delete ... build\flutter_assets" no Windows,
# especialmente com projeto em OneDrive e Chrome de debug aberto).
Set-StrictMode -Version 3
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

Write-Host 'Dica: encerre o flutter run anterior (Ctrl+C ou q) e feche a aba de debug do Chrome se a limpeza falhar.' -ForegroundColor DarkYellow

function Remove-DirRobust([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) { return }
  cmd /c "rmdir /s /q `"$Path`"" | Out-Null
}

$maxAttempts = 6
for ($i = 1; $i -le $maxAttempts; $i++) {
  Remove-DirRobust -Path 'build'
  if (-not (Test-Path -LiteralPath 'build')) { break }
  Write-Host "Tentativa $i/$maxAttempts : ainda nao foi possivel remover 'build'. Aguardando 2s..." -ForegroundColor Yellow
  Start-Sleep -Seconds 2
}

if (Test-Path -LiteralPath 'build') {
  Write-Host "ERRO: Nao foi possivel apagar a pasta 'build'. Feche o Chrome (abas do Flutter) e tente de novo, ou mova o projeto para fora do OneDrive (ex.: C:\dev)." -ForegroundColor Red
  exit 1
}

foreach ($rel in @(
    'windows\flutter\ephemeral',
    'ios\Flutter\ephemeral',
    'macos\Flutter\ephemeral',
    'linux\flutter\ephemeral'
  )) {
  Remove-DirRobust -Path $rel
}

if ($args -and $args.Count -gt 0) {
  flutter run -d chrome @args
} else {
  flutter run -d chrome
}
