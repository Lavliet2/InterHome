# Скрипт для создания IPA файла из .app bundle для устройства
Write-Host "Создание IPA файла для iOS устройства..." -ForegroundColor Yellow

# Проверка наличия распакованного артефакта
$appBundlePath = "ios-app-bundle-device\InterHome.app"
if (-not (Test-Path $appBundlePath)) {
    Write-Host "Ошибка: Не найден .app bundle в папке ios-app-bundle-device" -ForegroundColor Red
    Write-Host "Убедитесь, что вы распаковали артефакт ios-app-bundle-device.zip" -ForegroundColor Yellow
    exit 1
}

Write-Host "Найден .app bundle: $appBundlePath" -ForegroundColor Green

# Создание структуры для IPA
Write-Host "`nСоздание структуры Payload..." -ForegroundColor Yellow
if (Test-Path "Payload") {
    Remove-Item -Path "Payload" -Recurse -Force
}
New-Item -ItemType Directory -Path "Payload" -Force | Out-Null

# Копирование .app bundle в Payload
Write-Host "Копирование .app bundle в Payload..." -ForegroundColor Yellow
Copy-Item -Path $appBundlePath -Destination "Payload\InterHome.app" -Recurse -Force

# Проверка размера
$size = (Get-ChildItem -Path "Payload" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "Размер bundle: $([math]::Round($size, 2)) MB" -ForegroundColor Green

# Создание IPA
Write-Host "`nСоздание IPA файла..." -ForegroundColor Yellow
if (Test-Path "InterHome-device.ipa") {
    Remove-Item -Path "InterHome-device.ipa" -Force
}
Compress-Archive -Path "Payload" -DestinationPath "InterHome-device.ipa" -Force

# Проверка результата
$ipaSize = (Get-Item "InterHome-device.ipa").Length / 1MB
Write-Host "IPA файл создан: InterHome-device.ipa ($([math]::Round($ipaSize, 2)) MB)" -ForegroundColor Green

# Очистка
Write-Host "`nОчистка временных файлов..." -ForegroundColor Yellow
Remove-Item -Path "Payload" -Recurse -Force

Write-Host "`n✓ Готово! Используйте InterHome-device.ipa в Sideloadly или iMazing" -ForegroundColor Green

