# Скрипт для создания чистого IPA файла без старой подписи
Write-Host "=== Создание IPA файла для iOS устройства ===" -ForegroundColor Cyan
Write-Host ""

$zipPath = "C:\Users\Lavliet\Downloads\ios-app-bundle-device.zip"
$extractPath = "C:\Users\Lavliet\Downloads\ios-app-bundle-device"
$appBundlePath = "C:\Users\Lavliet\Downloads\InterHome.app"
$payloadPath = "C:\Users\Lavliet\Downloads\Payload"
$ipaPath = "C:\Users\Lavliet\Downloads\InterHome-device.ipa"

# Шаг 1: Проверка наличия ZIP файла
Write-Host "[1/5] Проверка ZIP файла..." -ForegroundColor Yellow
if (-not (Test-Path $zipPath)) {
    Write-Host "✗ Ошибка: ZIP файл не найден: $zipPath" -ForegroundColor Red
    exit 1
}
$zipSize = (Get-Item $zipPath).Length / 1MB
Write-Host "✓ ZIP файл найден: $([math]::Round($zipSize, 2)) MB" -ForegroundColor Green

# Шаг 2: Распаковка архива
Write-Host "`n[2/5] Распаковка архива..." -ForegroundColor Yellow
if (Test-Path $extractPath) {
    Remove-Item -Path $extractPath -Recurse -Force
}
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
Write-Host "✓ Архив распакован" -ForegroundColor Green

# Шаг 3: Удаление старой подписи и создание .app bundle
Write-Host "`n[3/5] Удаление старой подписи и создание .app bundle..." -ForegroundColor Yellow
if (Test-Path $appBundlePath) {
    Remove-Item -Path $appBundlePath -Recurse -Force
}
New-Item -ItemType Directory -Path $appBundlePath -Force | Out-Null

# Копируем все файлы из распакованной папки в .app bundle
Get-ChildItem -Path $extractPath | Copy-Item -Destination $appBundlePath -Recurse -Force

# Удаляем папку _CodeSignature (старая подпись)
if (Test-Path "$appBundlePath\_CodeSignature") {
    Remove-Item -Path "$appBundlePath\_CodeSignature" -Recurse -Force
    Write-Host "✓ Удалена старая подпись (_CodeSignature)" -ForegroundColor Green
}

# Проверяем наличие ключевых файлов
if (-not (Test-Path "$appBundlePath\InterHome")) {
    Write-Host "⚠ Предупреждение: Исполняемый файл InterHome не найден" -ForegroundColor Yellow
}
if (-not (Test-Path "$appBundlePath\Info.plist")) {
    Write-Host "⚠ Предупреждение: Info.plist не найден" -ForegroundColor Yellow
}

$bundleSize = (Get-ChildItem -Path $appBundlePath -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "✓ .app bundle создан: $([math]::Round($bundleSize, 2)) MB" -ForegroundColor Green

# Шаг 4: Создание структуры Payload
Write-Host "`n[4/5] Создание структуры Payload..." -ForegroundColor Yellow
if (Test-Path $payloadPath) {
    Remove-Item -Path $payloadPath -Recurse -Force
}
New-Item -ItemType Directory -Path $payloadPath -Force | Out-Null
Copy-Item -Path $appBundlePath -Destination "$payloadPath\InterHome.app" -Recurse -Force
Write-Host "✓ Структура Payload создана" -ForegroundColor Green

# Шаг 5: Создание IPA файла
Write-Host "`n[5/5] Создание IPA файла..." -ForegroundColor Yellow
if (Test-Path $ipaPath) {
    Remove-Item -Path $ipaPath -Force
}
Compress-Archive -Path $payloadPath -DestinationPath $ipaPath -Force
$ipaSize = (Get-Item $ipaPath).Length / 1MB
Write-Host "✓ IPA файл создан: $([math]::Round($ipaSize, 2)) MB" -ForegroundColor Green

# Очистка временных файлов
Write-Host "`nОчистка временных файлов..." -ForegroundColor Yellow
Remove-Item -Path $extractPath, $appBundlePath, $payloadPath -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "✓ Временные файлы удалены" -ForegroundColor Green

# Итоговый результат
Write-Host "`n" + "="*50 -ForegroundColor Cyan
Write-Host "✓✓✓ ГОТОВО! ✓✓✓" -ForegroundColor Green
Write-Host "="*50 -ForegroundColor Cyan
Write-Host "IPA файл: $ipaPath" -ForegroundColor Cyan
Write-Host "Размер: $([math]::Round($ipaSize, 2)) MB" -ForegroundColor Cyan
Write-Host "`nТеперь используйте этот файл в Sideloadly:" -ForegroundColor Yellow
Write-Host "1. Откройте Sideloadly" -ForegroundColor White
Write-Host "2. Перетащите IPA файл в область IPA" -ForegroundColor White
Write-Host "3. Убедитесь, что НЕ включен 'No-resign mode' (должен быть выключен)" -ForegroundColor White
Write-Host "4. Введите Apple ID и нажмите Start" -ForegroundColor White

