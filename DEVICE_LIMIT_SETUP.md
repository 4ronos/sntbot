# Настройка выбора количества устройств

## Описание

Добавлена функциональность выбора количества устройств при покупке подписки. Цена рассчитывается как базовая цена (RUB_PRICE_1_MONTH) умноженная на количество устройств.

## Новые настройки в .env

```env
# Device Limit Configuration
# Эти значения будут переданы в RemnaWave panel как HWID_FALLBACK_DEVICE_LIMIT
DEVICE_LIMIT_1=1
DEVICE_LIMIT_2=2
DEVICE_LIMIT_3=3
DEVICE_LIMIT_4=4
DEVICE_LIMIT_5=5
DEVICE_LIMIT_6=6
DEVICE_LIMIT_CUSTOM=10
```

## Изменения в базе данных

Добавлены поля `device_limit` в таблицы:
- `payments` - для хранения количества устройств в записи о платеже
- `subscriptions` - для хранения количества устройств в подписке

### Миграция

Выполните SQL-миграцию:

```sql
-- Добавить поле device_limit в таблицу payments
ALTER TABLE payments ADD COLUMN device_limit INTEGER DEFAULT 1;

-- Добавить поле device_limit в таблицу subscriptions  
ALTER TABLE subscriptions ADD COLUMN device_limit INTEGER DEFAULT 1;
```

## Логика работы

1. **Выбор количества устройств**: При нажатии кнопки "Купить" пользователь сначала выбирает количество устройств (1-6 или свое значение)
2. **Расчет цены**: Цена = базовая цена × количество устройств
3. **Выбор периода**: После выбора количества устройств пользователь выбирает период подписки с уже рассчитанной ценой
4. **Передача в панель**: Количество устройств передается в RemnaWave panel как `hwidFallbackDeviceLimit`

## Новые строки локализации

### Русский (ru.json)
```json
{
  "select_device_limit": "Выберите количество устройств:",
  "device_limit_button": "{devices} устройств",
  "device_limit_custom_button": "Свое количество",
  "enter_custom_device_limit": "Введите количество устройств (от 1 до 50):",
  "invalid_device_limit": "Неверное количество устройств. Введите число от 1 до 50."
}
```

### Английский (en.json)
```json
{
  "select_device_limit": "Select number of devices:",
  "device_limit_button": "{devices} devices",
  "device_limit_custom_button": "Custom amount",
  "enter_custom_device_limit": "Enter number of devices (1-50):",
  "invalid_device_limit": "Invalid number of devices. Enter a number from 1 to 50."
}
```

## Отображение в деталях подписки

В деталях подписки теперь отображается количество устройств:

```
🔐 Моя подписка:

Статус: Активна
Активна до: 2024-12-31 (осталось дней: 30)

Трафик: 2.50 GB из 10.00 GB
Устройств: 3

Ссылка на конфигурацию:
<code>https://your-config-link.com</code>
```

## Технические детали

### Измененные файлы:
- `config/settings.py` - добавлены настройки device_limit
- `db/models.py` - добавлены поля device_limit
- `bot/keyboards/inline/user_keyboards.py` - новые клавиатуры для выбора устройств
- `bot/handlers/user/subscription.py` - обновлена логика покупки
- `bot/services/subscription_service.py` - поддержка device_limit
- `bot/services/stars_service.py` - поддержка device_limit
- `bot/services/crypto_pay_service.py` - поддержка device_limit
- `bot/services/tribute_service.py` - поддержка device_limit
- `locales/ru.json` и `locales/en.json` - новые строки локализации

### Новые callback_data форматы:
- `device_limit:1` - выбор 1 устройства
- `device_limit:custom` - выбор своего количества
- `subscribe_period:3:2` - выбор 3 месяцев для 2 устройств
- `pay_yk:3:598:2` - оплата 3 месяцев для 2 устройств (цена 598 руб)

## Настройка цен

Цены настраиваются в .env файле как базовая цена за 1 устройство:

```env
RUB_PRICE_1_MONTH=299    # 299 руб за 1 месяц для 1 устройства
RUB_PRICE_3_MONTHS=799   # 799 руб за 3 месяца для 1 устройства
```

При выборе 3 устройств цена будет:
- 1 месяц: 299 × 3 = 897 руб
- 3 месяца: 799 × 3 = 2397 руб
