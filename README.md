<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=6,11,20&height=200&section=header&text=MoriiStar%20Bot%20Setup&fontSize=50&fontColor=fff&animation=twinkling&fontAlignY=35&desc=اسکریپت%20نصب%20خودکار%20ربات%20تلگرام&descAlignY=55&descSize=20" width="100%"/>

<br/>

[![GitHub](https://img.shields.io/badge/GitHub-moriistar-181717?style=for-the-badge&logo=github)](https://github.com/moriistar)
[![Telegram](https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=for-the-badge&logo=telegram)](https://t.me/ServerStar_ir)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://github.com/moriistar)
[![Python](https://img.shields.io/badge/Python-3.10-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

<br/>

> 🤖 با یک خط دستور، سرور خود را آماده کنید و ربات تلگرام را راه‌اندازی نمایید!

</div>

---

## 📋 فهرست مطالب

- [✨ ویژگی‌ها](#-ویژگیها)
- [⚡ نصب سریع](#-نصب-سریع)
- [🔧 پیش‌نیازها](#-پیشنیازها)
- [🚀 مراحل نصب](#-مراحل-نصب)
- [⚙️ پیکربندی](#️-پیکربندی)
- [▶️ اجرای ربات](#️-اجرای-ربات)
- [📁 ساختار پروژه](#-ساختار-پروژه)
- [🛠 عیب‌یابی](#-عیبیابی)
- [👤 توسعه‌دهنده](#-توسعهدهنده)

---

## ✨ ویژگی‌ها

<div dir="rtl">

| ویژگی | توضیح |
|:---:|:---|
| ⚡ **نصب یک‌کلیکی** | کل محیط را با یک دستور آماده می‌کند |
| 🐍 **Python 3.10** | نصب خودکار پایتون و pip |
| 🌐 **Clone هوشمند** | اگر پروژه بود آپدیت، اگر نبود Clone می‌کند |
| 🔒 **محیط مجازی** | ایزوله‌سازی کامل با venv |
| 📦 **نصب خودکار پکیج‌ها** | نصب requirements.txt و پکیج‌های پایه |
| ⚙️ **سرویس systemd** | اجرای خودکار ربات پس از ریست سرور |
| 🎨 **خروجی رنگی** | نمایش وضعیت با رنگ‌های مشخص |
| 🔍 **بررسی اینترنت** | تست اتصال قبل از شروع نصب |

</div>

---

## ⚡ نصب سریع

فقط کافیست این یک خط را در سرور خود اجرا کنید:

```bash
curl -sSL https://raw.githubusercontent.com/moriistar/setup-bot/main/install.sh | bash
```

یا با `wget`:

```bash
wget -O install.sh https://raw.githubusercontent.com/moriistar/setup-bot/main/install.sh && chmod +x install.sh && bash install.sh
```

---

## 🔧 پیش‌نیازها

| مورد | حداقل نسخه |
|:---|:---:|
| سیستم‌عامل | Ubuntu 20.04 / Debian 11 |
| دسترسی | Root یا Sudo |
| اینترنت | ✅ الزامی |
| RAM | 512 MB |
| فضای دیسک | 1 GB |

---

## 🚀 مراحل نصب

اسکریپت به‌صورت خودکار مراحل زیر را انجام می‌دهد:

```
مرحله ۱ ── آپدیت مخازن سیستم (apt update & upgrade)
    │
مرحله ۲ ── نصب پیش‌نیازهای پایه (git, curl, wget, ...)
    │
مرحله ۳ ── نصب Python 3.10 و pip
    │
مرحله ۴ ── دریافت سورس کد از GitHub (clone / pull)
    │
مرحله ۵ ── ساخت محیط مجازی (venv)
    │
مرحله ۶ ── نصب پکیج‌های پایتون
    │
مرحله ۷ ── پیکربندی فایل .env
    │
مرحله ۸ ── ساخت سرویس systemd
    │
    └── ✅ ربات آماده اجراست!
```

---

## ⚙️ پیکربندی

پس از نصب، فایل `.env` را ویرایش کنید:

```bash
nano .env
```

```env
# ═══════════════════════════════════════
#   تنظیمات ربات تلگرام - MoriiStar
# ═══════════════════════════════════════

# توکن ربات (از @BotFather دریافت کنید)
BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz

# آیدی عددی مدیر اصلی ربات
ADMIN_ID=123456789

# آیدی کانال یا گروه
CHANNEL_ID=@ServerStar_ir

# نوع محیط
ENV=production

# پورت فلاسک (اختیاری)
PORT=5000
```

> ⚠️ **هرگز فایل `.env` را در گیت‌هاب آپلود نکنید!**

---

## ▶️ اجرای ربات

### روش ۱ — اجرای مستقیم

```bash
cd TelegramBot
source venv/bin/activate
python main.py
```

### روش ۲ — اجرا با Screen (پس‌زمینه)

```bash
screen -S mybot
source venv/bin/activate
python main.py
```

> برای خروج از screen بدون بستن ربات: `Ctrl+A` سپس `D`
> برای بازگشت: `screen -r mybot`

### روش ۳ — اجرا با سرویس Systemd (توصیه شده)

```bash
# شروع سرویس
sudo systemctl start telegram-bot

# توقف سرویس
sudo systemctl stop telegram-bot

# مشاهده وضعیت
sudo systemctl status telegram-bot

# مشاهده لاگ‌های زنده
journalctl -u telegram-bot -f
```

---

## 📁 ساختار پروژه

```
TelegramBot/
│
├── 📄 main.py              ← فایل اصلی ربات
├── 📄 requirements.txt     ← لیست پکیج‌های پایتون
├── 📄 .env                 ← تنظیمات محیطی (نباید در گیت باشد)
├── 📄 .gitignore           ← فایل‌های نادیده گرفته شده
│
├── 📁 venv/                ← محیط مجازی پایتون
├── 📁 handlers/            ← هندلرهای ربات
├── 📁 utils/               ← ابزارهای کمکی
└── 📁 database/            ← فایل‌های دیتابیس
```

---

## 🛠 عیب‌یابی

<details>
<summary>❌ خطای Permission denied</summary>

```bash
chmod +x install.sh
sudo bash install.sh
```
</details>

<details>
<summary>❌ خطای python3.10 not found</summary>

```bash
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.10 -y
```
</details>

<details>
<summary>❌ خطای git clone failed</summary>

نام ریپازیتوری را در فایل `install.sh` بررسی کنید:
```bash
REPO_NAME="نام-ریپازیتوری-صحیح"
```
</details>

<details>
<summary>❌ ربات اجرا نمی‌شود</summary>

```bash
# بررسی لاگ سرویس
journalctl -u telegram-bot -n 50

# یا اجرای دستی برای دیدن خطا
source venv/bin/activate
python main.py
```
</details>

---

## 👤 توسعه‌دهنده

<div align="center">

| | |
|:---:|:---|
| 👤 **نام** | MoriiStar |
| 💻 **گیت‌هاب** | [@moriistar](https://github.com/moriistar) |
| 📢 **کانال** | [@ServerStar_ir](https://t.me/ServerStar_ir) |

<br/>

<a href="https://github.com/moriistar">
  <img src="https://img.shields.io/github/followers/moriistar?label=Follow&style=social" />
</a>

<br/><br/>

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=6,11,20&height=100&section=footer" width="100%"/>

</div>
