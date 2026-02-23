#!/bin/bash

# ========================================
# XVS Theme Installer for Pterodactyl
# Arix-Inspired Modern UI
# One-line installation: curl -fsSL https://your-site.com/install.sh | bash
# ========================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
THEME_NAME="XVS Theme"
THEME_VERSION="1.0.0"
THEME_AUTHOR="Your Name"
PANEL_DIR="/var/www/pterodactyl"
BACKUP_DIR="/root/pterodactyl-backup-$(date +%Y%m%d_%H%M%S)"

# Print banner
echo -e "${PURPLE}"
echo '╔══════════════════════════════════════════════════════════╗'
echo '║                                                          ║'
echo '║   ██╗  ██╗██╗   ██╗███████╗    ████████╗██╗  ██╗███████╗███╗   ███╗███████╗'
echo '║   ╚██╗██╔╝██║   ██║██╔════╝    ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝'
echo '║    ╚███╔╝ ██║   ██║███████╗       ██║   ███████║█████╗  ██╔████╔██║█████╗  '
echo '║    ██╔██╗ ██║   ██║╚════██║       ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  '
echo '║   ██╔╝ ██╗╚██████╔╝███████║       ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗'
echo '║   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝       ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝'
echo '║                                                          ║'
echo '║            Arix-Inspired Premium Pterodactyl Theme       ║'
echo '║                    Version 1.0.0                         ║'
echo '╚══════════════════════════════════════════════════════════╝'
echo -e "${NC}"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}❌ This script must be run as root${NC}" 
   exit 1
fi

# Check if panel exists
if [ ! -d "$PANEL_DIR" ]; then
    echo -e "${RED}❌ Pterodactyl panel not found in $PANEL_DIR${NC}"
    echo -e "${YELLOW}Please install Pterodactyl first and try again.${NC}"
    exit 1
fi

echo -e "${CYAN}📁 Panel found at: $PANEL_DIR${NC}"

# Create backup
echo -e "${YELLOW}📦 Creating backup before installation...${NC}"
mkdir -p "$BACKUP_DIR"
cp -r "$PANEL_DIR"/* "$BACKUP_DIR" 2>/dev/null || true
echo -e "${GREEN}✅ Backup created at: $BACKUP_DIR${NC}"

# Enter maintenance mode
echo -e "${YELLOW}🔧 Entering maintenance mode...${NC}"
cd "$PANEL_DIR"
php artisan down --retry=60

# Create theme directory
echo -e "${YELLOW}📁 Creating theme directory...${NC}"
mkdir -p "$PANEL_DIR/public/themes/xvs/css"
mkdir -p "$PANEL_DIR/resources/views/layouts"

# Download theme files (replace with your actual URLs)
echo -e "${YELLOW}⬇️  Downloading XVS Theme files...${NC}"

# Create the CSS file directly (in a real scenario, you'd download from your server)
cat > "$PANEL_DIR/public/themes/xvs/css/xvs-theme.css" << 'EOF'
/* XVS Theme CSS - Paste the entire CSS content from File 1 here */
EOF

# Create wrapper file
cat > "$PANEL_DIR/resources/views/layouts/admin.blade.php" << 'EOF'
{{-- XVS Theme Wrapper - Paste the entire wrapper content from File 2 here --}}
EOF

# Install dependencies
echo -e "${YELLOW}📦 Installing Node dependencies...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Installing Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
fi

if ! command -v yarn &> /dev/null; then
    echo -e "${YELLOW}Installing Yarn...${NC}"
    npm install -g yarn
fi

cd "$PANEL_DIR"
yarn install

# Build assets
echo -e "${YELLOW}🔨 Building panel assets...${NC}"
yarn run production

# Set permissions
echo -e "${YELLOW}🔒 Setting permissions...${NC}"
chown -R www-data:www-data "$PANEL_DIR"
chmod -R 755 "$PANEL_DIR/storage"
chmod -R 755 "$PANEL_DIR/bootstrap/cache"

# Clear cache
echo -e "${YELLOW}🧹 Clearing cache...${NC}"
php artisan view:clear
php artisan config:clear
php artisan cache:clear

# Exit maintenance mode
php artisan up

echo -e "${GREEN}══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ XVS Theme installed successfully!${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}Theme Information:${NC}"
echo -e "  Name: ${PURPLE}$THEME_NAME${NC}"
echo -e "  Version: ${PURPLE}$THEME_VERSION${NC}"
echo -e "  Author: ${PURPLE}$THEME_AUTHOR${NC}"
echo ""
echo -e "${CYAN}Installation Details:${NC}"
echo -e "  Panel Directory: ${PURPLE}$PANEL_DIR${NC}"
echo -e "  Backup Location: ${PURPLE}$BACKUP_DIR${NC}"
echo ""
echo -e "${CYAN}What's Next?${NC}"
echo -e "  1. Visit your panel at: ${PURPLE}https://your-domain.com${NC}"
echo -e "  2. Clear your browser cache (Ctrl+F5)"
echo -e "  3. Enjoy your new Arix-inspired theme!"
echo ""
echo -e "${YELLOW}To restore backup if needed:${NC}"
echo -e "  cp -r $BACKUP_DIR/* $PANEL_DIR/"
echo ""
echo -e "${GREEN}══════════════════════════════════════════════════════════${NC}"
