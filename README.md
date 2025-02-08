# Terraform Infrastructure as Code

Этот проект представляет собой инфраструктурный код для развертывания различных сервисов в облаке с помощью Terraform.

## Структура проекта

```
terraform/
├── providers/                    # Провайдер-специфичный код
│   └── gcp/                     # Google Cloud Platform
│       ├── modules/             # Переиспользуемые модули
│       │   ├── instance/        # Базовый модуль для создания VM
│       │   └── mysql/          # Модуль для MySQL серверов
│       └── environments/        # Окружения (dev, stage, prod)
│           └── dev/            # Development окружение
│               └── mysql/      # MySQL конфигурация
├── scripts/                     # Скрипты для настройки сервисов
│   └── mysql/                  # Скрипты для MySQL
└── configs/                     # Конфигурационные файлы
    └── ssh/                    # SSH ключи
```

## Подготовка к работе

### 1. Требования

- [Terraform](https://www.terraform.io/downloads.html) (версия >= 1.0.0)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- Активный аккаунт GCP с необходимыми правами
- SSH ключ для доступа к VM

### 2. Настройка окружения

1. Создайте SSH ключи:
```powershell
# Создание директории для ключей
mkdir -p configs/ssh

# Генерация ключей (замените username на ваше имя без кириллицы)
ssh-keygen -t ed25519 -f "configs/ssh/id_ed25519" -C "username"

# Важно:
# 1. Не устанавливайте пароль на ключ (просто нажмите Enter)
# 2. Используйте только латинские символы в комментарии к ключу
# 3. Проверьте созданный ключ:
Get-Content "configs/ssh/id_ed25519.pub"
# Он должен выглядеть примерно так:
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... username
```

2. Настройте Google Cloud SDK:
```bash
# Авторизация в GCP
gcloud auth login

# Установка проекта по умолчанию
gcloud config set project ваш-project-id
```

## Развертывание сервисов

### MySQL Server

1. Перейдите в директорию окружения:
```bash
cd providers/gcp/environments/dev/mysql
```

2. Создайте файл `terraform.tfvars`:
```hcl
project_id          = "ваш-project-id"
region              = "europe-west4"
zone                = "europe-west4-b"
instance_name       = "mysql-dev"
machine_type        = "e2-medium"
ssh_username        = "ваш-username"  # Используйте ваш Gmail без @gmail.com
ssh_pub_key_path    = "../../../../../configs/ssh/id_ed25519.pub"
mysql_root_password = "сложный-пароль-root"
mysql_database      = "имя-базы-данных"  # Опционально
mysql_user          = "имя-пользователя"  # Опционально
mysql_password      = "пароль-пользователя"  # Опционально
```

3. Инициализируйте и примените конфигурацию:
```bash
terraform init
terraform apply
```

## Подключение к серверам

### SSH подключение

1. Через gcloud (рекомендуемый способ):
```bash
gcloud compute ssh --zone=europe-west4-b ваш-username@mysql-dev
```

2. Напрямую через SSH:
```bash
# Получите внешний IP сервера
terraform output mysql_instance_ip

# Подключитесь используя SSH ключ
# ВАЖНО: 
# 1. Используйте полный путь к ключу
# 2. Используйте только имя пользователя БЕЗ @gmail.com
ssh -i "C:/Python_projects_actual/Terraform/configs/ssh/id_ed25519" ваш-username@<ip-адрес>

Пример:
```bash
# Если ваш email bratkovsky.ilia@gmail.com, используйте:
ssh -i "C:/Python_projects_actual/Terraform/configs/ssh/id_ed25519" bratkovsky.ilia@34.32.159.65
```

### Проверка SSH доступа

1. Проверьте содержимое публичного ключа:
```powershell
Get-Content "configs/ssh/id_ed25519.pub"
# Должно быть что-то вроде:
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... bratkovsky
```

2. Убедитесь, что в terraform.tfvars указаны правильные значения:
```hcl
ssh_username        = "bratkovsky"  # Только имя пользователя, без @gmail.com и без кириллицы
ssh_pub_key_path    = "../../../../../configs/ssh/id_ed25519.pub"
```

3. Если что-то изменили, пересоздайте инстанс:
```powershell
terraform destroy
terraform apply
```

4. Подключитесь к серверу:
```powershell
# Через gcloud (рекомендуется)
gcloud compute ssh --zone=europe-west4-b bratkovsky@mysql-dev

# Или напрямую через SSH
ssh -i "C:/Python_projects_actual/Terraform/configs/ssh/id_ed25519" bratkovsky@34.90.146.153
```

Важно:
- Используйте имя пользователя БЕЗ @gmail.com
- В имени пользователя должны быть только латинские буквы
- Путь к ключу должен быть относительным от директории terraform.tfvars
- При первом подключении ответьте 'yes' на вопрос о доверии к серверу

### SSH подключение через PuTTY

1. Конвертируйте OpenSSH ключ в формат PuTTY:
```bash
# Скачайте PuTTYgen с официального сайта
# Запустите PuTTYgen
# Выберите Conversions -> Import key
# Выберите ваш configs/ssh/id_ed25519
# Нажмите Save private key
# Сохраните как id_ed25519.ppk
```

2. Настройте подключение в PuTTY:
- Session:
  - Host Name: внешний IP сервера (из terraform output mysql_instance_ip)
  - Port: 22
  - Connection type: SSH
- Connection -> SSH -> Auth:
  - Private key file: путь к id_ed25519.ppk
- Connection -> Data:
  - Auto-login username: ваш-username (тот же, что в terraform.tfvars)
- Session:
  - Сохраните сессию под удобным именем

3. Подключитесь, нажав Open

Примечание: При первом подключении PuTTY спросит о доверии к серверу - нажмите Yes.

### Подключение к MySQL

1. Подключитесь к серверу через SSH:
```bash
# Через gcloud (рекомендуется)
gcloud compute ssh --zone=europe-west4-b bratkovsky@mysql-dev

# Или напрямую через SSH
ssh -i "C:/Python_projects_actual/Terraform/configs/ssh/id_ed25519" bratkovsky@34.32.159.65
```

2. После подключения к серверу, подключитесь к MySQL:
```bash
sudo mysql -u root -p
# Введите пароль root из terraform.tfvars
```

3. Удаленное подключение (например, через DBeaver):
- Host: <ip-адрес> (получите через terraform output mysql_instance_ip)
- Port: 3306
- User: созданный пользователь
- Password: пароль пользователя
- SSL: Disabled

## Управление MySQL

### Основные команды

1. Просмотр пользователей:
```sql
SELECT User, Host FROM mysql.user;
```

2. Создание базы данных и пользователя:
```sql
CREATE DATABASE myapp;
CREATE USER 'myuser'@'%' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON myapp.* TO 'myuser'@'%';
FLUSH PRIVILEGES;
```

3. Просмотр прав:
```sql
SHOW GRANTS FOR 'myuser'@'%';
```

### Проверка работы сервера

```bash
# Статус службы
sudo systemctl status mysql

# Проверка портов
sudo netstat -tlpn | grep mysql

# Просмотр логов
sudo tail -f /var/log/mysql/error.log
```

## Управление пользователями MySQL

### Создание пользователей

1. Подключитесь к MySQL как root:
```bash
sudo mysql -u root -p
# Введите пароль root из terraform.tfvars
```

2. Создайте нового пользователя:
```sql
-- Создать пользователя с доступом с любого хоста (%)
CREATE USER 'username'@'%' IDENTIFIED BY 'password';

-- Или создать пользователя с доступом только с localhost
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
```

3. Предоставьте права пользователю:
```sql
-- Все права на конкретную базу данных
GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'%';

-- Или только определенные права
GRANT SELECT, INSERT, UPDATE, DELETE ON database_name.* TO 'username'@'%';

-- Или все права на все базы (как root)
GRANT ALL PRIVILEGES ON *.* TO 'username'@'%' WITH GRANT OPTION;

-- Применить изменения
FLUSH PRIVILEGES;
```

### Управление существующими пользователями

1. Просмотр всех пользователей:
```sql
SELECT User, Host FROM mysql.user;
```

2. Просмотр прав пользователя:
```sql
SHOW GRANTS FOR 'username'@'%';
```

3. Изменение пароля пользователя:
```sql
ALTER USER 'username'@'%' IDENTIFIED BY 'new_password';
```

4. Удаление прав:
```sql
-- Удалить все права
REVOKE ALL PRIVILEGES ON database_name.* FROM 'username'@'%';

-- Удалить конкретное право
REVOKE DELETE ON database_name.* FROM 'username'@'%';
```

5. Удаление пользователя:
```sql
DROP USER 'username'@'%';
```

### Примеры

1. Создание пользователя для веб-приложения:
```sql
-- Создаем базу данных
CREATE DATABASE myapp;

-- Создаем пользователя
CREATE USER 'myapp_user'@'%' IDENTIFIED BY 'strong_password';

-- Даем права только на нужную базу
GRANT SELECT, INSERT, UPDATE, DELETE ON myapp.* TO 'myapp_user'@'%';

-- Применяем изменения
FLUSH PRIVILEGES;
```

2. Создание пользователя для аналитика:
```sql
-- Создаем пользователя с правами только на чтение
CREATE USER 'analyst'@'%' IDENTIFIED BY 'analyst_password';
GRANT SELECT ON *.* TO 'analyst'@'%';
FLUSH PRIVILEGES;
```

## Безопасность

- Все пароли хранятся в `terraform.tfvars` (добавьте в .gitignore)
- SSH доступ только по ключу
- MySQL порт (3306) открыт для всех IP (0.0.0.0/0) - рекомендуется ограничить
- Рекомендуется использовать секреты через Vault или Secret Manager

## Удаление инфраструктуры

Для удаления всех ресурсов:
```bash
cd providers/gcp/environments/dev/mysql
terraform destroy
```

## Troubleshooting

### Проблемы с SSH

1. Проверьте права на SSH ключ:
```bash
chmod 600 configs/ssh/id_ed25519
```

2. Проверьте firewall правила в GCP:
```bash
gcloud compute firewall-rules list
```

### Проблемы с MySQL

1. Проверьте статус и логи:
```bash
sudo systemctl status mysql
sudo tail -f /var/log/mysql/error.log
```

2. Проверьте конфигурацию:
```bash
sudo mysqld --verbose --help
```

3. Проверьте подключения:
```bash
sudo netstat -tlpn | grep mysql

```

## Работа с Git

### Клонирование и настройка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/bratkovskiy/terraform.git
cd terraform
```

2. Создайте необходимые директории и файлы:
```bash
# Создайте директорию для SSH ключей
mkdir -p configs/ssh

# Создайте SSH ключи
ssh-keygen -t ed25519 -f configs/ssh/id_ed25519 -C "your_username"
```

3. Настройте terraform.tfvars (не коммитится в Git):
```bash
cd providers/gcp/environments/dev/mysql
cp terraform.tfvars.example terraform.tfvars
# Отредактируйте terraform.tfvars под свои нужды
```

### Правила работы с репозиторием

1. Не коммитьте чувствительные данные:
- terraform.tfvars
- Ключи SSH
- Файлы учетных данных (.json)
- Состояние Terraform (.tfstate)

2. Не коммитьте бинарные файлы:
- Директории .terraform
- Бинарные файлы провайдеров

3. Перед коммитом проверяйте изменения:
```bash
git status
git diff
```

4. Используйте осмысленные сообщения коммитов:
```bash
git commit -m "Add new MySQL module with configuration"
