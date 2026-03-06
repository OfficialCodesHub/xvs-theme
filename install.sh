#!/bin/bash

# XVS Theme Installer for Pterodactyl
# Arix-Inspired Modern UI
# Repo: https://github.com/Lorinplayz/xvs-theme

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Print banner
echo -e "${PURPLE}"
echo '╔══════════════════════════════════════════════════════════╗'
echo '║                                                          ║'
echo '║   ██╗  ██╗██╗   ██╗███████╗    ████████╗██╗  ██╗███████╗'
echo '║   ╚██╗██╔╝██║   ██║██╔════╝    ╚══██╔══╝██║  ██║██╔════╝'
echo '║    ╚███╔╝ ██║   ██║███████╗       ██║   ███████║█████╗  '
echo '║    ██╔██╗ ██║   ██║╚════██║       ██║   ██╔══██║██╔══╝  '
echo '║   ██╔╝ ██╗╚██████╔╝███████║       ██║   ██║  ██║███████╗'
echo '║   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝       ╚═╝   ╚═╝  ╚═╝╚══════╝'
echo '║                                                          ║'
echo '║            Arix-Inspired Premium Pterodactyl Theme       ║'
echo '║                    Version 1.0.0                         ║'
echo '║                by AyushTheWarrior                           ║'
echo '╚══════════════════════════════════════════════════════════╝'
echo -e "${NC}"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}❌ This script must be run as root${NC}" 
   exit 1
fi

# Panel directory
PANEL_DIR="/var/www/pterodactyl"

# Check if panel exists
if [ ! -d "$PANEL_DIR" ]; then
    echo -e "${RED}❌ Pterodactyl panel not found in $PANEL_DIR${NC}"
    exit 1
fi

echo -e "${CYAN}📁 Panel found at: $PANEL_DIR${NC}"

# Create backup
BACKUP_DIR="/root/pterodactyl-backup-$(date +%Y%m%d_%H%M%S)"
echo -e "${YELLOW}📦 Creating backup...${NC}"
mkdir -p "$BACKUP_DIR"
cp -r "$PANEL_DIR"/* "$BACKUP_DIR" 2>/dev/null || true
echo -e "${GREEN}✅ Backup created at: $BACKUP_DIR${NC}"

# Enter maintenance mode
echo -e "${YELLOW}🔧 Entering maintenance mode...${NC}"
cd "$PANEL_DIR"
php artisan down --retry=60

# Create theme directory
echo -e "${YELLOW}📁 Creating theme directory...${NC}"
mkdir -p "$PANEL_DIR/public/themes/xvs"

# Download theme CSS from GitHub
echo -e "${YELLOW}⬇️  Downloading XVS Theme CSS...${NC}"
curl -fsSL https://raw.githubusercontent.com/Lorinplayz/xvs-theme/main/xvs-theme.css -o "$PANEL_DIR/public/themes/xvs/xvs-theme.css"

# Download wrapper
echo -e "${YELLOW}⬇️  Downloading theme wrapper...${NC}"
curl -fsSL https://raw.githubusercontent.com/Lorinplayz/xvs-theme/main/wrapper.blade.php -o "$PANEL_DIR/resources/views/layouts/admin.blade.php"

# Install dependencies and build
echo -e "${YELLOW}🔨 Building assets...${NC}"
if command -v yarn &> /dev/null; then
    yarn install
    yarn run production
else
    npm install
    npm run production
fi

# Set permissions
echo -e "${YELLOW}🔒 Setting permissions...${NC}"
chown -R www-data:www-data "$PANEL_DIR"
chmod -R 755 "$PANEL_DIR/storage" "$PANEL_DIR/bootstrap/cache"

# Clear cache
echo -e "${YELLOW}🧹 Clearing cache...${NC}"
php artisan view:clear
php artisan config:clear
php artisan cache:clear

# Exit maintenance mode
php artisan up

# Get server IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')

echo -e "${GREEN}══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ XVS Theme installed successfully!${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}📊 Installation Details:${NC}"
echo -e "  Theme: ${PURPLE}XVS Theme v1.0.0${NC}"
echo -e "  Author: ${PURPLE}Lorinplayz${NC}"
echo -e "  Panel: ${PURPLE}$PANEL_DIR${NC}"
echo -e "  Backup: ${PURPLE}$BACKUP_DIR${NC}"
echo ""
echo -e "${CYAN}🌐 Access your panel:${NC}"
echo -e "  ${PURPLE}http://$SERVER_IP${NC}"
echo ""
echo -e "${GREEN}══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🎉 Enjoy your Arix-inspired XVS Theme!${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════════${NC}"
