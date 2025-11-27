#!/bin/bash
################################################################################
# TradingView Multi-Window Launcher - macOS Installer (Enhanced v2.0)
# One-click installation script with tickers.txt support
################################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# Banner
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  TradingView Multi-Window Launcher - Enhanced v2.0 (macOS)║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Get installation directory
INSTALL_DIR="$HOME/TradingViewLauncher"

print_info "Installation directory: $INSTALL_DIR"
echo ""

# Step 1: Check Python
echo "═══════════════════════════════════════════════════════════"
echo "Step 1: Checking Python installation..."
echo "═══════════════════════════════════════════════════════════"

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    print_success "Python 3 found (version $PYTHON_VERSION)"
else
    print_error "Python 3 not found!"
    print_info "Please install Python 3 from: https://www.python.org/downloads/"
    print_info "Or install via Homebrew: brew install python3"
    exit 1
fi

# Step 2: Check Chrome
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 2: Checking Google Chrome installation..."
echo "═══════════════════════════════════════════════════════════"

if [ -d "/Applications/Google Chrome.app" ]; then
    print_success "Google Chrome found"
else
    print_warning "Google Chrome not found!"
    print_info "Please install Chrome from: https://www.google.com/chrome/"
    read -p "Press Enter after installing Chrome, or Ctrl+C to exit..."
fi

# Step 3: Check/Install Homebrew
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 3: Checking Homebrew (package manager)..."
echo "═══════════════════════════════════════════════════════════"

if command -v brew &> /dev/null; then
    print_success "Homebrew found"
else
    print_warning "Homebrew not found. Installing Homebrew..."
    print_info "This may take a few minutes..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed"
fi

# Step 4: Install Rectangle
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 4: Installing Rectangle (window manager)..."
echo "═══════════════════════════════════════════════════════════"

if [ -d "/Applications/Rectangle.app" ]; then
    print_success "Rectangle already installed"
else
    print_info "Installing Rectangle..."
    brew install --cask rectangle
    print_success "Rectangle installed"
fi

# Step 5: Create installation directory
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 5: Creating installation directory..."
echo "═══════════════════════════════════════════════════════════"

mkdir -p "$INSTALL_DIR"
print_success "Directory created: $INSTALL_DIR"

# Step 6: Copy enhanced Python script
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 6: Installing TradingView Launcher script (Enhanced)..."
echo "═══════════════════════════════════════════════════════════"

# Get the enhanced script from the same directory as installer
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -f "$SCRIPT_DIR/launch_trading_windows_enhanced.py" ]; then
    cp "$SCRIPT_DIR/launch_trading_windows_enhanced.py" "$INSTALL_DIR/launch_trading_windows.py"
    print_success "Script installed from local file"
else
    print_info "Creating embedded script..."
    # If the enhanced script isn't found, create it inline
    cat > "$INSTALL_DIR/launch_trading_windows.py" << 'PYTHON_SCRIPT_END'
#!/usr/bin/env python3
"""TradingView Multi-Window Launcher with tickers.txt support"""
import subprocess, time, sys, platform, os

def get_script_directory():
    return os.path.dirname(os.path.abspath(__file__))

def get_chrome_path():
    os_name = platform.system()
    if os_name == 'Darwin':
        return '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    return 'google-chrome'

def read_tickers_from_file():
    script_dir = get_script_directory()
    tickers_file = os.path.join(script_dir, 'tickers.txt')
    
    if not os.path.exists(tickers_file):
        print("📝 Creating default tickers.txt...")
        with open(tickers_file, 'w') as f:
            f.write("# TradingView Tickers - One per line\n\nSPY\nQQQ\nIWM\nCME_MINI:ES1!\n")
        print(f"✅ Created: {tickers_file}\n")
    
    tickers = []
    with open(tickers_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                tickers.append(line)
    
    return tickers if tickers else ['SPY', 'QQQ', 'IWM', 'CME_MINI:ES1!']

def main():
    print("\n╔════════════════════════════════════════╗")
    print("║ TradingView Multi-Window Launcher     ║")
    print("╚════════════════════════════════════════╝\n")
    
    tickers = read_tickers_from_file()
    print(f"📖 Found {len(tickers)} ticker(s): {', '.join(tickers)}\n")
    
    chrome_path = get_chrome_path()
    
    print("Opening windows...\n")
    for i, ticker in enumerate(tickers, 1):
        url = f"https://www.tradingview.com/chart/?symbol={ticker}"
        print(f"  [{i}/{len(tickers)}] {ticker}")
        subprocess.Popen([chrome_path, '--new-window', url])
        time.sleep(1.2)
    
    print(f"\n✅ Opened {len(tickers)} window(s)!")
    print(f"\n💡 Edit tickers: {os.path.join(get_script_directory(), 'tickers.txt')}")
    print("   Then run this again!\n")

if __name__ == "__main__":
    main()
PYTHON_SCRIPT_END
    print_success "Script created"
fi

chmod +x "$INSTALL_DIR/launch_trading_windows.py"

# Step 7: Create tickers.txt
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 7: Creating tickers.txt configuration file..."
echo "═══════════════════════════════════════════════════════════"

cat > "$INSTALL_DIR/tickers.txt" << 'TICKERS_END'
# TradingView Multi-Window Launcher - Tickers Configuration
# ===========================================================
#
# HOW TO USE:
# • Add one ticker per line
# • Lines starting with # are comments (ignored)
# • Save this file and run the launcher again
#
# SUPPORTED LAYOUTS (automatic):
# • 1 ticker  → Full screen
# • 2 tickers → Side by side
# • 4 tickers → 2×2 grid
# • 6 tickers → 2×3 grid
# • 9 tickers → 3×3 grid
#
# TICKER EXAMPLES:
# • Stocks: AAPL, TSLA, MSFT
# • ETFs: SPY, QQQ, IWM
# • Forex: EURUSD, GBPUSD
# • Crypto: BTCUSD, ETHUSD
# • Futures: ES1!, NQ1!, GC1!
#
# ===========================================================

# DEFAULT TICKERS (US Market Overview)
SPY
QQQ
IWM
CME_MINI:ES1!

# POPULAR STOCKS (Uncomment to use)
# AAPL
# TSLA
# MSFT
# GOOGL
# NVDA

# FOREX (Uncomment to use)
# EURUSD
# GBPUSD

# CRYPTO (Uncomment to use)
# BTCUSD
# ETHUSD

# ===========================================================
# Edit this file anytime, save, and run launcher again!
# ===========================================================
TICKERS_END

print_success "tickers.txt created with examples"
print_info "Location: $INSTALL_DIR/tickers.txt"

# Step 8: Create launcher script
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 8: Creating launcher command..."
echo "═══════════════════════════════════════════════════════════"

cat > "$INSTALL_DIR/launch.command" << 'LAUNCHER'
#!/bin/bash
cd "$(dirname "$0")"
python3 launch_trading_windows.py
LAUNCHER

chmod +x "$INSTALL_DIR/launch.command"
print_success "Launcher created"

# Step 9: Create Desktop shortcuts
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 9: Creating Desktop shortcuts..."
echo "═══════════════════════════════════════════════════════════"

# Launcher shortcut
ln -sf "$INSTALL_DIR/launch.command" "$HOME/Desktop/TradingView Launcher.command"

# Tickers editor shortcut
ln -sf "$INSTALL_DIR/tickers.txt" "$HOME/Desktop/Edit Tickers.txt"

print_success "Desktop shortcuts created"
print_info "• TradingView Launcher.command - Run the app"
print_info "• Edit Tickers.txt - Edit your ticker list"

# Step 10: Configure Rectangle
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 10: Configuring Rectangle..."
echo "═══════════════════════════════════════════════════════════"

print_info "Opening Rectangle to verify shortcuts..."
print_info "Please check these shortcuts are set:"
echo "  • Top Left Quarter: Ctrl + Option + U"
echo "  • Top Right Quarter: Ctrl + Option + I"
echo "  • Bottom Left Quarter: Ctrl + Option + J"
echo "  • Bottom Right Quarter: Ctrl + Option + K"
echo ""

open -a Rectangle 2>/dev/null || print_warning "Please open Rectangle manually"

sleep 2

# Step 11: Setup accessibility permissions
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 11: Setting up accessibility permissions..."
echo "═══════════════════════════════════════════════════════════"

print_warning "IMPORTANT: Grant accessibility permissions!"
echo ""
print_info "Opening System Preferences..."
echo ""
echo "Please do the following:"
echo "  1. Go to: Privacy & Security → Accessibility"
echo "  2. Click the lock icon to make changes"
echo "  3. Add 'Terminal' to the list (click + button)"
echo "  4. Make sure it's checked/enabled"
echo ""

open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility" 2>/dev/null

sleep 2

# Create README
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Step 12: Creating README..."
echo "═══════════════════════════════════════════════════════════"

cat > "$INSTALL_DIR/README.txt" << 'README_END'
TradingView Multi-Window Launcher - README (Enhanced v2.0)
===========================================================

QUICK START:
------------
1. Edit tickers:
   • Double-click "Edit Tickers.txt" on your Desktop
   • Add your tickers (one per line)
   • Save and close

2. Launch:
   • Double-click "TradingView Launcher" on your Desktop
   • Windows will open and auto-arrange!

TICKER EXAMPLES:
----------------
Stocks:  AAPL, TSLA, MSFT, GOOGL
ETFs:    SPY, QQQ, IWM
Forex:   EURUSD, GBPUSD
Crypto:  BTCUSD, ETHUSD
Futures: ES1!, NQ1!, GC1!

TIPS:
-----
• Start with 4-6 tickers
• Rectangle must be running for auto-arrangement
• Edit tickers.txt anytime and relaunch
• Use # for comments in tickers.txt

PERMISSIONS:
------------
Grant accessibility permissions to Terminal:
System Preferences → Privacy & Security → Accessibility

SUPPORT:
--------
Installation: ~/TradingViewLauncher
Tickers file: ~/TradingViewLauncher/tickers.txt

Happy Trading! 📈
README_END

print_success "README.txt created"

# Final message
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  INSTALLATION COMPLETE!                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
print_success "TradingView Multi-Window Launcher (Enhanced) installed!"
echo ""
echo "📍 Installation: $INSTALL_DIR"
echo "🖥️  Desktop shortcuts created:"
echo "   • TradingView Launcher.command"
echo "   • Edit Tickers.txt"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "QUICK START:"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "1️⃣  EDIT TICKERS:"
echo "   Double-click 'Edit Tickers.txt' on Desktop"
echo "   Add your favorite tickers (one per line)"
echo "   Save and close"
echo ""
echo "2️⃣  LAUNCH:"
echo "   Double-click 'TradingView Launcher' on Desktop"
echo ""
echo "3️⃣  DONE!"
echo "   Windows open and arrange automatically! 🎉"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "EXAMPLE SETUPS:"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Day Trader (4):     Tech Focus (6):    Forex (4):"
echo "  SPY                 AAPL               EURUSD"
echo "  QQQ                 MSFT               GBPUSD"
echo "  IWM                 GOOGL              USDJPY"
echo "  ES1!                NVDA               AUDUSD"
echo "                      TSLA"
echo "                      QQQ"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "BEFORE FIRST USE:"
echo "═══════════════════════════════════════════════════════════"
echo "✓ Rectangle is running (should be automatic)"
echo "✓ Grant accessibility permissions to Terminal"
echo "✓ Edit tickers.txt with your watchlist"
echo ""
print_info "Opening tickers.txt for you to customize..."
sleep 1
open -a TextEdit "$INSTALL_DIR/tickers.txt"

echo ""
print_success "Setup complete! Enjoy your trading setup! 📈"
echo ""