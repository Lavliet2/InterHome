# Как использовать Personal Access Token для push

## Вариант 1: Добавить токен в URL (временный)

Выполните команду, заменив `ВАШ_ТОКЕН` на ваш токен:

```powershell
git remote set-url origin https://ВАШ_ТОКЕН@github.com/Lavliet2/InterHome.git
git push origin main
```

**Важно**: После этого токен будет сохранен в конфигурации Git. Если хотите удалить его позже:
```powershell
git remote set-url origin https://github.com/Lavliet2/InterHome.git
```

---

## Вариант 2: Использовать Git Credential Manager (рекомендуется)

### Windows:

1. При следующем push Git запросит учетные данные
2. Введите:
   - **Username**: ваш логин GitHub (Lavliet2)
   - **Password**: ваш токен (НЕ пароль от GitHub!)

### Или настройте заранее:

```powershell
# Настроить credential helper
git config --global credential.helper wincred

# При следующем push введите токен как пароль
git push origin main
```

---

## Вариант 3: Через переменную окружения (для одного push)

```powershell
$env:GIT_ASKPASS = "echo"
git push origin main
# При запросе введите токен
```

---

## Проверка

После настройки выполните:

```powershell
git push origin main
```

Если всё настроено правильно, push должен пройти успешно!

---

## Безопасность

⚠️ **Важно**: 
- Не коммитьте токен в код!
- Не публикуйте токен в открытых местах
- Токен имеет те же права, что и ваш аккаунт
- Если токен скомпрометирован, немедленно удалите его в GitHub Settings → Developer settings → Personal access tokens

