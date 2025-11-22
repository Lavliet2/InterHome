# Скрипт для решения проблем с блокировкой файлов NuGet
Write-Host "Поиск процессов, которые могут блокировать файлы NuGet..." -ForegroundColor Yellow

# Поиск процессов MSBuild, Visual Studio и dotnet
$processes = Get-Process | Where-Object {
    $_.ProcessName -like "*msbuild*" -or 
    $_.ProcessName -like "*devenv*" -or 
    $_.ProcessName -like "*dotnet*" -or
    $_.ProcessName -like "*MSBuild*"
}

if ($processes) {
    Write-Host "`nНайдены следующие процессы:" -ForegroundColor Yellow
    $processes | Format-Table ProcessName, Id, Path -AutoSize
    
    Write-Host "`nПопытка завершить процессы..." -ForegroundColor Yellow
    foreach ($proc in $processes) {
        try {
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
            Write-Host "Процесс $($proc.ProcessName) (ID: $($proc.Id)) завершен" -ForegroundColor Green
        } catch {
            Write-Host "Не удалось завершить процесс $($proc.ProcessName) (ID: $($proc.Id))" -ForegroundColor Red
        }
    }
} else {
    Write-Host "Процессы не найдены. Возможно, файлы заблокированы антивирусом или другим системным процессом." -ForegroundColor Yellow
}

Write-Host "`nОжидание 3 секунды перед восстановлением пакетов..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

Write-Host "`nОчистка папок bin и obj..." -ForegroundColor Yellow
if (Test-Path "InterHome\bin") { 
    Remove-Item -Recurse -Force "InterHome\bin" -ErrorAction SilentlyContinue 
    Write-Host "Папка bin удалена" -ForegroundColor Green
}
if (Test-Path "InterHome\obj") { 
    Remove-Item -Recurse -Force "InterHome\obj" -ErrorAction SilentlyContinue 
    Write-Host "Папка obj удалена" -ForegroundColor Green
}

Write-Host "`nВосстановление пакетов NuGet..." -ForegroundColor Yellow
dotnet restore

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nПакеты успешно восстановлены!" -ForegroundColor Green
} else {
    Write-Host "`nОшибка при восстановлении пакетов." -ForegroundColor Red
    Write-Host "Попробуйте:" -ForegroundColor Yellow
    Write-Host "1. Закрыть Visual Studio полностью" -ForegroundColor Yellow
    Write-Host "2. Закрыть все окна терминала" -ForegroundColor Yellow
    Write-Host "3. Перезапустить компьютер" -ForegroundColor Yellow
    Write-Host "4. Запустить этот скрипт от имени администратора" -ForegroundColor Yellow
}

