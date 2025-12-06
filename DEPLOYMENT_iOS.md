# Инструкция по развертыванию InterHome на iPhone

## Требования

1. **Mac с macOS** (обязательно для сборки iOS приложений)
2. **Xcode** (последняя версия из App Store)
3. **Apple Developer аккаунт**:
   - Бесплатный аккаунт Apple ID (для разработки на своем устройстве)
   - Или платный Apple Developer Program ($99/год) для публикации в App Store
4. **iPhone** с iOS 15.0 или выше
5. **Visual Studio для Mac** или **Visual Studio Code** с расширениями для .NET MAUI

## Подготовка проекта

### 1. Настройка Apple Developer аккаунта

#### Вариант A: Бесплатный аккаунт (для тестирования на своем iPhone)

1. Откройте **Xcode** на Mac
2. Перейдите в **Xcode → Settings → Accounts**
3. Нажмите **+** и добавьте свой Apple ID
4. Выберите ваш Apple ID и нажмите **Download Manual Profiles** (если доступно)

#### Вариант B: Платный аккаунт (для публикации)

1. Зарегистрируйтесь на [developer.apple.com](https://developer.apple.com)
2. Оплатите подписку ($99/год)
3. Настройте сертификаты и профили в Xcode

### 2. Подключение iPhone

1. Подключите iPhone к Mac через USB кабель
2. На iPhone: **Настройки → Основные → VPN и управление устройством**
3. Разблокируйте iPhone и доверьтесь компьютеру (если появится запрос)
4. В Xcode: **Window → Devices and Simulators**
5. Убедитесь, что iPhone определяется и статус "Ready"

### 3. Настройка проекта в Visual Studio для Mac

1. Откройте решение `InterHome.slnx` в Visual Studio для Mac
2. Выберите проект **InterHome**
3. В **Solution Explorer** щелкните правой кнопкой на проекте → **Options**
4. Перейдите в **iOS Bundle Signing**:
   - **Signing Identity**: Выберите ваш Apple ID или Team
   - **Provisioning Profile**: Выберите автоматический профиль или создайте новый
   - Убедитесь, что **Bundle Identifier** = `com.companyname.interhome`

### 4. Настройка Bundle Identifier (если нужно изменить)

Если нужно изменить Bundle Identifier, откройте `InterHome.csproj` и измените:

```xml
<ApplicationId>com.yourcompany.interhome</ApplicationId>
```

**Важно**: Bundle Identifier должен быть уникальным и соответствовать вашему Apple Developer аккаунту.

## Развертывание на iPhone

### Способ 1: Через Visual Studio для Mac (рекомендуется)

1. В Visual Studio для Mac выберите проект **InterHome**
2. В верхней панели выберите:
   - **Configuration**: `Debug` или `Release`
   - **Platform**: `iPhone` (или конкретное устройство из списка)
3. Нажмите кнопку **Play** (▶) или **Run → Run Without Debugging**
4. Выберите ваш подключенный iPhone из списка устройств
5. Дождитесь сборки и установки приложения

**При первом запуске на iPhone:**
- На iPhone появится сообщение о недоверенном разработчике
- Перейдите: **Настройки → Основные → VPN и управление устройством**
- Найдите ваше приложение и нажмите **Доверять**

### Способ 2: Через командную строку (dotnet CLI)

Если вы используете командную строку на Mac:

```bash
# Перейдите в папку проекта
cd InterHome

# Восстановите пакеты
dotnet restore

# Соберите проект для iOS
dotnet build -f net10.0-ios -c Debug

# Разверните на подключенное устройство
dotnet build -f net10.0-ios -c Debug -t:Run
```

### Способ 3: Через Xcode (альтернативный)

1. Соберите проект в Visual Studio для Mac
2. Откройте папку `InterHome/Platforms/iOS/` в Xcode
3. В Xcode выберите ваше устройство
4. Нажмите **Run** (▶)

## Решение проблем

### Ошибка: "No valid provisioning profile found"

**Решение:**
1. В Visual Studio для Mac: **Project Options → iOS Bundle Signing**
2. Выберите правильный **Signing Identity** и **Provisioning Profile**
3. Или используйте **Automatic Provisioning** (рекомендуется)

### Ошибка: "Device not found"

**Решение:**
1. Убедитесь, что iPhone подключен и разблокирован
2. Проверьте в Xcode: **Window → Devices and Simulators**
3. Перезапустите Visual Studio для Mac

### Ошибка: "Untrusted Developer"

**Решение:**
1. На iPhone: **Настройки → Основные → VPN и управление устройством**
2. Найдите ваше приложение в списке
3. Нажмите **Доверять [ваш email]**

### Ошибка: "This app cannot be installed because its integrity could not be verified"

**Решение:**
1. Убедитесь, что используется правильный Provisioning Profile
2. Проверьте, что Bundle Identifier совпадает в проекте и профиле
3. Пересоберите проект с правильными настройками подписи

## Публикация в App Store (опционально)

Если вы хотите опубликовать приложение в App Store:

1. Создайте **App Store Connect** запись для вашего приложения
2. Настройте **Archive** в Visual Studio для Mac:
   - **Build → Archive for Publishing**
3. Откройте **Archive Manager** и загрузите архив в App Store Connect
4. Завершите процесс публикации в App Store Connect

## Дополнительные ресурсы

- [Документация .NET MAUI для iOS](https://learn.microsoft.com/dotnet/maui/ios/deployment/overview)
- [Руководство по подписи приложений iOS](https://learn.microsoft.com/dotnet/maui/ios/deployment/bundle-signing)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)

## Способ 4: Сборка через GitHub Actions (БЕСПЛАТНО, без Mac!)

**Этот способ позволяет собрать iOS приложение БЕЗ наличия Mac!**

GitHub Actions предоставляет бесплатные macOS runners для публичных репозиториев и 2000 минут/месяц для приватных репозиториев.

### Настройка GitHub Actions

1. **Создайте репозиторий на GitHub** (если еще нет)
   - Публичный репозиторий = полностью бесплатно
   - Приватный = 2000 минут/месяц бесплатно

2. **Загрузите код в репозиторий**
   ```bash
   git add .
   git commit -m "Add iOS build workflow"
   git push origin main
   ```

3. **Запустите сборку**
   - Перейдите в репозиторий на GitHub
   - Вкладка **Actions**
   - Выберите workflow **Build iOS App**
   - Нажмите **Run workflow** → **Run workflow**

4. **Скачайте собранное приложение**
   - После завершения сборки перейдите в **Actions**
   - Откройте завершенный workflow run
   - В разделе **Artifacts** скачайте `ios-app-ipa` или `ios-app-bundle`

### Установка на iPhone (без подписи)

**Важно**: Приложение, собранное без подписи, можно установить только через:
- **AltStore** (требует AltServer на компьютере)
- **Sideloadly** (бесплатный инструмент для установки)
- **3uTools** (альтернативный вариант)

**Шаги установки через Sideloadly:**
1. Скачайте [Sideloadly](https://sideloadly.io/) на Windows/Mac
2. Подключите iPhone к компьютеру
3. Откройте Sideloadly и выберите скачанный `.ipa` файл
4. Введите ваш Apple ID (бесплатный аккаунт подойдет)
5. Нажмите **Start** и дождитесь установки
6. На iPhone: **Настройки → Основные → VPN и управление устройством** → **Доверьте** приложению

### Подписанная сборка (для установки напрямую)

Для создания подписанного `.ipa`, который можно установить напрямую:

1. **Подготовьте сертификаты** (нужен Apple Developer аккаунт):
   - Экспортируйте сертификат разработчика (.p12)
   - Экспортируйте Provisioning Profile (.mobileprovision)

2. **Настройте GitHub Secrets**:
   - Перейдите в репозиторий → **Settings** → **Secrets and variables** → **Actions**
   - Добавьте следующие секреты:
     - `APPLE_CERTIFICATE_BASE64` - Base64 кодированный .p12 файл
     - `APPLE_CERTIFICATE_PASSWORD` - Пароль от сертификата
     - `APPLE_PROVISIONING_PROFILE_BASE64` - Base64 кодированный .mobileprovision
     - `APPLE_TEAM_ID` - Ваш Team ID
     - `APPLE_CERTIFICATE_NAME` - Имя сертификата (например, "Apple Development")
     - `KEYCHAIN_PASSWORD` - Пароль для временного keychain

3. **Запустите подписанную сборку**:
   - Используйте workflow **Build iOS App (Signed)**
   - Выберите конфигурацию (Debug/Release)
   - После сборки скачайте подписанный `.ipa`

### Преимущества GitHub Actions

✅ **Полностью бесплатно** для публичных репозиториев  
✅ **Не нужен Mac** - сборка происходит в облаке  
✅ **Автоматическая сборка** при каждом push  
✅ **Артефакты хранятся 30-90 дней**  
✅ **2000 минут/месяц** для приватных репозиториев  

### Ограничения

⚠️ Для подписанной сборки нужен Apple Developer аккаунт ($99/год)  
⚠️ Бесплатная подпись работает только на ваших устройствах (до 3 устройств)  
⚠️ Приложения без подписи требуют специальных инструментов для установки  

## Примечания

- Для сборки iOS приложений **обязательно нужен Mac** - сборка на Windows невозможна
- **НО**: GitHub Actions предоставляет бесплатные macOS runners для сборки!
- Если у вас нет Mac, используйте **GitHub Actions** (см. Способ 4 выше)
- Альтернативы: облачные сервисы (MacStadium, MacinCloud) или Mac mini
- Бесплатный Apple ID позволяет тестировать приложения только на ваших собственных устройствах (до 3 устройств)
- Для тестирования на других устройствах или публикации нужен платный Apple Developer Program

