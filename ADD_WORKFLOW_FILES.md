# Как добавить workflow файлы в GitHub

GitHub не позволяет добавлять workflow файлы через обычный git push без специальных прав. Добавьте их через веб-интерфейс:

## Способ 1: Через веб-интерфейс GitHub (рекомендуется)

### Шаг 1: Создайте папку для workflows

1. Откройте ваш репозиторий: https://github.com/Lavliet2/InterHome
2. Нажмите кнопку **"Add file"** → **"Create new file"**
3. В поле имени файла введите: `.github/workflows/build-ios.yml`
   - GitHub автоматически создаст папку `.github/workflows/`

### Шаг 2: Добавьте содержимое первого workflow файла

Скопируйте и вставьте содержимое файла `build-ios.yml` (см. ниже)

### Шаг 3: Сохраните файл

1. Нажмите **"Commit new file"** внизу страницы
2. Добавьте сообщение коммита: `Add iOS build workflow`
3. Нажмите **"Commit new file"**

### Шаг 4: Добавьте второй workflow файл

Повторите шаги 1-3 для файла `.github/workflows/build-ios-signed.yml`

---

## Способ 2: Через GitHub Desktop или другой Git клиент

Если у вас установлен GitHub Desktop или другой Git клиент с полными правами:

1. Откройте репозиторий в Git клиенте
2. Убедитесь, что файлы `.github/workflows/build-ios.yml` и `.github/workflows/build-ios-signed.yml` есть локально
3. Сделайте commit и push через клиент

---

## Способ 3: Использовать Personal Access Token

Если хотите использовать командную строку:

1. Создайте Personal Access Token на GitHub:
   - Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Создайте токен с правами `workflow` и `repo`
2. Используйте токен для push:
   ```bash
   git remote set-url origin https://ВАШ_ТОКЕН@github.com/Lavliet2/InterHome.git
   git push origin main
   ```

---

## После добавления файлов

После того как workflow файлы будут добавлены в репозиторий:

1. Перейдите во вкладку **Actions** в вашем репозитории
2. Вы увидите workflow **"Build iOS App"**
3. Нажмите на него и выберите **"Run workflow"** → **"Run workflow"**
4. Дождитесь завершения сборки (10-15 минут)
5. Скачайте артефакт `.ipa` файл

---

## Содержимое файлов для копирования

### Файл 1: `.github/workflows/build-ios.yml`

См. файл `build-ios.yml` в локальной папке `.github/workflows/`

### Файл 2: `.github/workflows/build-ios-signed.yml`

См. файл `build-ios-signed.yml` в локальной папке `.github/workflows/`

