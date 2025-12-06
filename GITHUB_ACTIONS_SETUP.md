# Настройка GitHub Actions для сборки iOS приложения

## Быстрый старт

### 1. Создайте репозиторий на GitHub

Если у вас еще нет репозитория:
1. Зайдите на [github.com](https://github.com)
2. Создайте новый репозиторий (публичный = полностью бесплатно)
3. Загрузите код:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/ВАШ_ЛОГИН/InterHome.git
   git push -u origin main
   ```

### 2. Запустите сборку

1. Перейдите в репозиторий на GitHub
2. Вкладка **Actions**
3. Выберите **Build iOS App** в списке workflows
4. Нажмите **Run workflow** → **Run workflow**

### 3. Скачайте результат

После завершения сборки (обычно 10-15 минут):
1. Откройте завершенный workflow run
2. Прокрутите вниз до раздела **Artifacts**
3. Скачайте `ios-app-ipa` или `ios-app-bundle`

## Установка на iPhone

### Вариант 1: Через Sideloadly (рекомендуется)

1. **Скачайте Sideloadly**:
   - Windows/Mac: [sideloadly.io](https://sideloadly.io/)
   - Это бесплатный инструмент для установки приложений на iPhone

2. **Подготовьте iPhone**:
   - Разблокируйте iPhone
   - Подключите к компьютеру через USB
   - Доверьтесь компьютеру (если появится запрос)

3. **Установите приложение**:
   - Откройте Sideloadly
   - Перетащите скачанный `.ipa` файл в Sideloadly
   - Введите ваш Apple ID (бесплатный аккаунт подойдет)
   - Выберите ваш iPhone из списка
   - Нажмите **Start**

4. **Доверьтесь разработчику на iPhone**:
   - После установки на iPhone появится сообщение
   - Перейдите: **Настройки → Основные → VPN и управление устройством**
   - Найдите ваше приложение и нажмите **Доверять**

### Вариант 2: Через AltStore

1. Установите **AltServer** на компьютер
2. Установите **AltStore** на iPhone через AltServer
3. Используйте AltStore для установки `.ipa` файла

### Вариант 3: Через 3uTools

1. Скачайте [3uTools](https://www.3u.com/)
2. Подключите iPhone
3. Используйте функцию установки приложений

## Настройка подписанной сборки

Для создания подписанного `.ipa`, который можно установить напрямую без специальных инструментов:

### Шаг 1: Получите сертификаты

**Требуется Apple Developer аккаунт** (бесплатный Apple ID тоже работает для разработки):

1. Откройте Xcode на Mac (или используйте облачный Mac)
2. **Xcode → Settings → Accounts**
3. Добавьте ваш Apple ID
4. Выберите Apple ID → **Download Manual Profiles**
5. Создайте новый проект iOS в Xcode
6. В настройках проекта выберите ваш Team
7. Xcode автоматически создаст сертификат и профиль

### Шаг 2: Экспортируйте сертификат

1. Откройте **Keychain Access** на Mac
2. Найдите сертификат разработчика (типа "Apple Development: ...")
3. Щелкните правой кнопкой → **Export**
4. Сохраните как `.p12` файл с паролем
5. Конвертируйте в Base64:
   ```bash
   base64 -i certificate.p12 -o certificate_base64.txt
   ```

### Шаг 3: Экспортируйте Provisioning Profile

1. В Xcode: **Xcode → Settings → Accounts**
2. Выберите ваш Apple ID → **Download Manual Profiles**
3. Найдите профиль для вашего Bundle ID (`com.companyname.interhome`)
4. Скопируйте файл из `~/Library/MobileDevice/Provisioning Profiles/`
5. Конвертируйте в Base64:
   ```bash
   base64 -i profile.mobileprovision -o profile_base64.txt
   ```

### Шаг 4: Настройте GitHub Secrets

1. Перейдите в репозиторий → **Settings** → **Secrets and variables** → **Actions**
2. Нажмите **New repository secret**
3. Добавьте следующие секреты:

| Имя секрета | Значение | Описание |
|------------|----------|----------|
| `APPLE_CERTIFICATE_BASE64` | Содержимое `certificate_base64.txt` | Base64 кодированный .p12 сертификат |
| `APPLE_CERTIFICATE_PASSWORD` | Пароль от .p12 файла | Пароль, который вы указали при экспорте |
| `APPLE_PROVISIONING_PROFILE_BASE64` | Содержимое `profile_base64.txt` | Base64 кодированный .mobileprovision |
| `APPLE_TEAM_ID` | Ваш Team ID (например, ABC123DEFG) | Можно найти в Apple Developer Portal |
| `APPLE_CERTIFICATE_NAME` | `Apple Development` или `Apple Distribution` | Тип сертификата |
| `KEYCHAIN_PASSWORD` | Любой пароль (например, `build123`) | Пароль для временного keychain в GitHub Actions |

### Шаг 5: Запустите подписанную сборку

1. Перейдите в **Actions**
2. Выберите workflow **Build iOS App (Signed)**
3. Нажмите **Run workflow**
4. Выберите конфигурацию (Debug/Release)
5. После сборки скачайте подписанный `.ipa`

## Автоматическая сборка при push

Workflow `build-ios.yml` автоматически запускается при:
- Push в ветку `main`
- Изменениях в папке `InterHome/`
- Ручном запуске через **Run workflow**

## Ограничения GitHub Actions

### Бесплатные лимиты:
- **Публичные репозитории**: Неограниченно бесплатно ✅
- **Приватные репозитории**: 2000 минут/месяц бесплатно
- После лимита: $0.008 за минуту macOS runner

### Время сборки:
- Обычная сборка: ~10-15 минут
- Подписанная сборка: ~15-20 минут
- При 2000 минут/месяц можно собрать ~130-200 раз бесплатно

## Решение проблем

### Ошибка: "No provisioning profile found"

**Решение**: Используйте workflow без подписи (`build-ios.yml`) или настройте секреты для подписанной сборки.

### Ошибка: "IPA file not found"

**Решение**: Проверьте логи сборки. Возможно, сборка завершилась с ошибкой. Проверьте раздел **build-logs** в артефактах.

### Ошибка: "Certificate import failed"

**Решение**: 
- Убедитесь, что сертификат правильно закодирован в Base64
- Проверьте пароль от сертификата
- Убедитесь, что сертификат не истек

### Приложение не устанавливается на iPhone

**Решение**:
- Убедитесь, что используете правильный инструмент (Sideloadly, AltStore)
- Проверьте, что доверили разработчику в настройках iPhone
- Для подписанного приложения убедитесь, что Bundle ID совпадает с профилем

## Полезные ссылки

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Sideloadly](https://sideloadly.io/)
- [AltStore](https://altstore.io/)
- [Apple Developer Portal](https://developer.apple.com)

## Часто задаваемые вопросы

**Q: Нужен ли Mac для использования GitHub Actions?**  
A: Нет! GitHub Actions предоставляет бесплатные macOS runners в облаке.

**Q: Можно ли собрать приложение без Apple Developer аккаунта?**  
A: Да, но приложение будет без подписи и потребует специальных инструментов для установки (Sideloadly, AltStore).

**Q: Сколько стоит GitHub Actions?**  
A: Для публичных репозиториев - полностью бесплатно. Для приватных - 2000 минут/месяц бесплатно.

**Q: Можно ли автоматизировать установку на iPhone?**  
A: Нет, установка требует ручного вмешательства на iPhone (доверие разработчику).

**Q: Как часто можно собирать приложение?**  
A: Без ограничений для публичных репозиториев. Для приватных - в пределах 2000 минут/месяц.

