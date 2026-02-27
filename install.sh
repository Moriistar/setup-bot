#!/bin/bash

# ╔══════════════════════════════════════════════════════════════╗
# ║         اسکریپت نصب و راه‌اندازی خودکار ربات تلگرام         ║
# ║                  توسعه‌دهنده: MoriiStar                      ║
# ║              گیت‌هاب: github.com/moriistar                   ║
# ╚══════════════════════════════════════════════════════════════╝

# ─────────────── تنظیمات اصلی ───────────────
GITHUB_USER="moriistar"
REPO_NAME="TelegramBot"        # ← نام ریپازیتوری اصلی ربات خود را اینجا بنویسید
PYTHON_VERSION="3.10"          # ← نسخه پایتون دلخواه
BRANCH="main"                  # ← نام برنچ اصلی

# ─────────────── رنگ‌های خروجی ───────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ─────────────── توابع کمکی ───────────────
info()    { echo -e "${CYAN}[INFO]${RESET}  $1"; }
success() { echo -e "${GREEN}[✔ OK]${RESET}  $1"; }
warning() { echo -e "${YELLOW}[WARN]${RESET}  $1"; }
error()   { echo -e "${RED}[✘ ERR]${RESET} $1"; exit 1; }

print_banner() {
    echo -e "${CYAN}"
    echo "  ███╗   ███╗ ██████╗ ██████╗ ██╗██╗███████╗████████╗ █████╗ ██████╗ "
    echo "  ████╗ ████║██╔═══██╗██╔══██╗██║██║██╔════╝╚══██╔══╝██╔══██╗██╔══██╗"
    echo "  ██╔████╔██║██║   ██║██████╔╝██║██║███████╗   ██║   ███████║██████╔╝"
    echo "  ██║╚██╔╝██║██║   ██║██╔══██╗██║██║╚════██║   ██║   ██╔══██║██╔══██╗"
    echo "  ██║ ╚═╝ ██║╚██████╔╝██║  ██║██║██║███████║   ██║   ██║  ██║██║  ██║"
    echo "  ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "${RESET}"
    echo -e "${BOLD}       🤖 Bot Auto-Installer | by MoriiStar${RESET}"
    echo -e "${BOLD}       🔗 github.com/${GITHUB_USER}${RESET}"
    echo    "  ──────────────────────────────────────────────"
    echo ""
}

# ─────────────── بررسی دسترسی root ───────────────
check_root() {
    if [ "$EUID" -ne 0 ]; then
        warning "پیشنهاد می‌شود اسکریپت با دسترسی root اجرا شود."
        warning "اجرا با sudo ادامه می‌یابد..."
    fi
}

# ─────────────── بررسی اتصال اینترنت ───────────────
check_internet() {
    info "بررسی اتصال به اینترنت..."
    if ! ping -c 1 github.com &>/dev/null; then
        error "اتصال به اینترنت برقرار نیست! لطفاً ابتدا اتصال را بررسی کنید."
    fi
    success "اتصال اینترنت برقرار است."
}

# ─────────────── مرحله ۱: آپدیت سیستم ───────────────
step1_update_system() {
    echo ""
    echo -e "${BOLD}━━━ مرحله ۱: آپدیت مخازن سیستم ━━━${RESET}"
    sudo apt-get update -y > /dev/null 2>&1 && success "مخازن سیستم آپدیت شد." || error "آپدیت سیستم با خطا مواجه شد."
    sudo apt-get upgrade -y > /dev/null 2>&1 && success "پکیج‌های سیستم ارتقا یافتند." || warning "ارتقای پکیج‌ها کامل نشد."
}

# ─────────────── مرحله ۲: نصب پیش‌نیازهای پایه ───────────────
step2_install_deps() {
    echo ""
    echo -e "${BOLD}━━━ مرحله ۲: نصب پیش‌نیازهای پایه ━━━${RESET}"
    PACKAGES="software-properties-common build-essential curl git wget unzip nano screen"
    info "در حال نصب: $PACKAGES"
    sudo apt-get install -y $PACKAGES > /dev/null 2>&1 && success "پیش‌نیازها نصب شدند." || error "نصب پیش‌نیازها با خطا مواجه شد."
}

# ─────────────── مرحله ۳: نصب پایتون ───────────────
step3_install_python() {
    echo ""
    echo -e "${BOLD}━━━ مرحله ۳: نصب Python ${PYTHON_VERSION} ━━━${RESET}"

    # بررسی نصب بودن پایتون
    if command -v python${PYTHON_VERSION} &>/dev/null; then
        success "Python ${PYTHON_VERSION} از قبل نصب است."
    else
        info "اضافه کردن مخزن deadsnakes..."
        sudo add-apt-repository ppa:deadsnakes/ppa -y > /dev/null 2>&1
        sudo apt-get update -y > /dev/null 2>&1
        info "نصب Python ${PYTHON_VERSION} ..."
        sudo apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-venv \
            python${PYTHON_VERSION}-dev python${PYTHON_VERSION}-distutils > /dev/null 2>&1 \
            && success "Python ${PYTHON_VERSION} نصب شد." \
            || error "نصب پایتون با خطا مواجه شد."
    fi

    # نصب pip
    if ! command -v pip3 &>/dev/null; then
        info "نصب pip..."
        curl -sS https://bootstrap.pypa.io/get-pip.py | python${PYTHON_VERSION} > /dev/null 2>&1
        success "pip نصب شد."
    else
        success "pip از قبل موجود است."
    fi
}

# ─────────────── مرحله ۴: دریافت سورس کد از گیت‌هاب ───────────────
step4_clone_repo() {
    echo ""
    echo -e "${BOLD}━━━ مرحله ۴: دریافت سورس از GitHub ━━━${RESET}"
    info "ریپازیتوری: github.com/${GITHUB_USER}/${REPO_NAME}"

    if [ -d "$REPO_NAME" ]; then
        warning "پوشه '$REPO_NAME' از قبل وجود دارد."
        info "دریافت آخرین تغییرات (git pull)..."
        cd "$REPO_NAME" || error "ورود به پوشه پروژه ناموفق بود."
        git pull origin "$BRANCH" && success "پروژه آپدیت شد." || warning "آپدیت گیت با مشکل مواجه شد."
    else
        info "کلون کردن ریپازیتوری..."
        git clone -b "$BRANCH" "https://github.com/${GITHUB_USER}/${REPO_NAME}.git" \
            && success "ریپازیتوری کلون شد." \
            || error "کلون ریپازیتوری ناموفق بود. آدرس را بررسی کنید."
        cd "$REPO_NAME" || error "ورود به پوشه پروژه ناموفق بود."
    fi
}

# ─────────────── مرحله ۵: ساخت محیط مجازی ───────────────
step5_create_venv() {
    echo ""
    echo -e "${BOLD}━━━ مرحله ۵: ساخت محیط مجازی (venv) ━━━${RESET}"

    if [ -d "venv" ]; then
        warning "محیط مجازی از قبل موجود است. استفاده از همان..."
    else
        info "ساخت محیط مجازی با Python ${PYTHON_VERSION}..."
        python${PYTHON_VERSION} -m venv venv && success "محیط مجازی ساخته شد." || error "ساخت محیط مجازی ناموفق بود."
    fi

    info "فعال‌سازی محیط مجازی..."
    source venv/bin/activate && success "محیط مجازی فعال شد." || error "فعال‌سازی محیط مجازی ناموفق بود."
}

# ─────────────── مرحله ۶: نصب پکیج‌های پایتون ───────────────
step6_install_packages() {
    echo ""
    echo -e "${BOLD}━━━ مرحله ۶: نصب پکیج‌های پایتون ━━━${RESET}"

    info "آپگرید pip..."
    pip install --upgrade pip > /dev/null 2>&1 && success "pip آپگرید شد."

    # پکیج‌های پایه ربات
    BASE_PACKAGES="pyTelegramBotAPI requests flask python-dotenv gunicorn aiohttp asyncio"
    info "نصب پکیج‌های پایه: $BASE_PACKAGES"
    pip install $BASE_PACKAGES > /dev/null 2>&1 && success "پکیج‌های پایه نصب شدند." || warning "برخی پکیج‌ها نصب نشدند."

    # بررسی و نصب requirements.txt
    if [ -f "requirements.txt" ]; then
        info "فایل requirements.txt پیدا شد. در حال نصب..."
        pip install -r requirements.txt > /dev/null 2>&1 && success "requirements.txt نصب شد." || warning "برخی وابستگی‌ها نصب نشدند."
    else
        warning "فایل requirements.txt پیدا نشد."
    fi
}

# ─────────────── مرحله ۷: پیکربندی فایل .env ───────────────
step7_setup_env() {
    echo ""
    echo -e "${BOLD}━━━ مرحله ۷: پیکربندی فایل محیطی (.env) ━━━${RESET}"

    if [ -f ".env" ]; then
        success "فایل .env از قبل موجود است. تغییری اعمال نشد."
    else
        info "ساخت فایل .env با مقادیر پیش‌فرض..."
        cat <<EOF > .env
# ═══════════════════════════════════════
#   تنظیمات ربات تلگرام - MoriiStar
# ═══════════════════════════════════════

# توکن ربات (از @BotFather دریافت کنید)
BOT_TOKEN=توکن_ربات_خود_را_اینجا_وارد_کنید

# آیدی عددی مدیر اصلی ربات
ADMIN_ID=آیدی_عددی_شما

# آیدی کانال یا گروه
CHANNEL_ID=@ServerStar_ir

# نوع اجرا (development / production)
ENV=production

# پورت فلاسک (اختیاری)
PORT=5000
EOF
        success "فایل .env ساخته شد."
        echo ""
        warning "⚠️  مهم: فایل .env را ویرایش کنید و اطلاعات واقعی را وارد نمایید:"
        echo -e "    ${YELLOW}nano .env${RESET}"
    fi
}

# ─────────────── مرحله ۸: تنظیم سرویس systemd (اختیاری) ───────────────
step8_setup_service() {
    echo ""
    echo -e "${BOLD}━━━ مرحله ۸: ساخت سرویس systemd ━━━${RESET}"

    BOT_DIR="$(pwd)"
    SERVICE_NAME="telegram-bot"

    if [ -f "/etc/systemd/system/${SERVICE_NAME}.service" ]; then
        warning "سرویس از قبل وجود دارد."
    else
        info "ساخت سرویس systemd برای اجرای خودکار ربات..."
        sudo bash -c "cat > /etc/systemd/system/${SERVICE_NAME}.service <<EOF
[Unit]
Description=Telegram Bot - MoriiStar
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=${BOT_DIR}
ExecStart=${BOT_DIR}/venv/bin/python main.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF"
        sudo systemctl daemon-reload
        sudo systemctl enable ${SERVICE_NAME}
        success "سرویس '${SERVICE_NAME}' ساخته و فعال شد."
        info "برای مشاهده لاگ: journalctl -u ${SERVICE_NAME} -f"
    fi
}

# ─────────────── نمایش خلاصه نهایی ───────────────
print_summary() {
    BOT_DIR="$(pwd)"
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║      ✅  ستاپ ربات با موفقیت به پایان رسید!         ║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "  📁 مسیر پروژه  : ${CYAN}${BOT_DIR}${RESET}"
    echo -e "  🐍 پایتون      : ${CYAN}Python ${PYTHON_VERSION}${RESET}"
    echo -e "  🌐 گیت‌هاب     : ${CYAN}github.com/${GITHUB_USER}/${REPO_NAME}${RESET}"
    echo ""
    echo -e "  ${BOLD}━━━ دستورات اجرای ربات ━━━${RESET}"
    echo -e "  ${YELLOW}# روش ۱ - اجرای مستقیم:${RESET}"
    echo -e "  cd ${BOT_DIR}"
    echo -e "  source venv/bin/activate"
    echo -e "  python main.py"
    echo ""
    echo -e "  ${YELLOW}# روش ۲ - اجرا با screen (پس‌زمینه):${RESET}"
    echo -e "  screen -S mybot"
    echo -e "  source venv/bin/activate && python main.py"
    echo -e "  ${CYAN}# برای خروج از screen: Ctrl+A سپس D${RESET}"
    echo ""
    echo -e "  ${YELLOW}# روش ۳ - اجرا با سرویس systemd:${RESET}"
    echo -e "  sudo systemctl start telegram-bot"
    echo -e "  sudo systemctl status telegram-bot"
    echo ""
    echo -e "  ${RED}⚠️  یادآوری: فایل .env را ویرایش کنید!${RESET}"
    echo -e "  nano .env"
    echo ""
    echo -e "${CYAN}  ── by MoriiStar ─ github.com/${GITHUB_USER} ──${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════
#                      اجرای اصلی
# ═══════════════════════════════════════════════════════
print_banner
check_root
check_internet
step1_update_system
step2_install_deps
step3_install_python
step4_clone_repo
step5_create_venv
step6_install_packages
step7_setup_env
step8_setup_service
print_summary
