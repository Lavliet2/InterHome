# Как исправить проблему с push workflow файлов

## Проблема
GitHub блокирует создание/обновление workflow файлов через OAuth без прав `workflow`.

## Решение 1: Обновить через веб-интерфейс (проще всего)

1. Откройте файл в GitHub:
   - https://github.com/Lavliet2/InterHome/edit/main/.github/workflows/build-ios.yml

2. Добавьте блок установки workload'ов после `Setup Xcode`:

```yaml
    - name: Install .NET MAUI workloads
      run: |
        dotnet workload restore
        dotnet workload install maui-ios --skip-sign-check
      working-directory: ${{ github.workspace }}
```

3. Сохраните изменения

---

## Решение 2: Использовать Personal Access Token

### Шаг 1: Создайте токен

1. Перейдите: https://github.com/settings/tokens
2. Нажмите **"Generate new token (classic)"**
3. Назовите токен: `GitHub Actions Workflow`
4. Выберите права:
   - ✅ `workflow` (обязательно!)
   - ✅ `repo` (для доступа к репозиторию)
5. Нажмите **"Generate token"**
6. **Скопируйте токен** (он показывается только один раз!)

### Шаг 2: Используйте токен для push

**Вариант A: Через URL (временный)**
```bash
git remote set-url origin https://ВАШ_ТОКЕН@github.com/Lavliet2/InterHome.git
git push origin main
```

**Вариант B: Через Git Credential Manager (постоянный)**
```bash
# Windows
git config --global credential.helper wincred

# При следующем push введите:
# Username: ваш_логин_github
# Password: ваш_токен (не пароль!)
```

**Вариант C: Через переменную окружения**
```bash
# Windows PowerShell
$env:GIT_ASKPASS = "echo"
git push origin main
# При запросе введите токен
```

---

## Решение 3: Обновить только основной workflow

Если не нужен workflow для подписанной сборки прямо сейчас:

1. Обновите только `build-ios.yml` через веб-интерфейс
2. Файл `build-ios-signed.yml` можно добавить позже, когда понадобится

---

## После обновления

После того как файл обновлен в GitHub:

1. Перейдите в **Actions**: https://github.com/Lavliet2/InterHome/actions
2. Выберите workflow **"Build iOS App"**
3. Нажмите **"Run workflow"** → **"Run workflow"**
4. Дождитесь завершения сборки

---

## Важно

- Personal Access Token нужно хранить в безопасности
- Не коммитьте токен в код!
- Можно использовать GitHub Secrets для хранения токенов в CI/CD


