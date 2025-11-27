#!/usr/bin/env python3
"""
TradingView Multi-Window Launcher with Rectangle
Opens Chrome windows with TradingView charts based on tickers.txt
Supports dynamic layouts for any number of tickers
"""

import subprocess
import time
import sys
import platform
import os
from pathlib import Path

def get_script_directory():
    """Get the directory where the script is located"""
    if getattr(sys, 'frozen', False):
        # If running as compiled executable
        return os.path.dirname(sys.executable)
    else:
        # If running as script
        return os.path.dirname(os.path.abspath(__file__))

def get_chrome_path():
    """Get the Chrome executable path based on OS"""
    os_name = platform.system()
    
    if os_name == 'Windows':
        paths = [
            'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
            'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
            os.path.expandvars('%LOCALAPPDATA%\\Google\\Chrome\\Application\\chrome.exe')
        ]
        for path in paths:
            if os.path.exists(path):
                return path
        return 'chrome'
    elif os_name == 'Darwin':  # macOS
        return '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    else:  # Linux
        return 'google-chrome'

def read_tickers_from_file():
    """Read tickers from tickers.txt file"""
    script_dir = get_script_directory()
    tickers_file = os.path.join(script_dir, 'tickers.txt')
    
    print(f"📂 Looking for tickers.txt at: {tickers_file}")
    
    # If tickers.txt doesn't exist, create it with defaults
    if not os.path.exists(tickers_file):
        print(f"📝 Creating default tickers.txt file...")
        default_tickers = """# TradingView Tickers Configuration
# One ticker per line
# Lines starting with # are comments
# Format: TICKER or EXCHANGE:TICKER

SPY
QQQ
IWM
CME_MINI:ES1!

# Examples of other tickers you can use:
# AAPL
# TSLA
# NASDAQ:GOOGL
# EURUSD
# BTCUSD
# GC1!
# CL1!
"""
        with open(tickers_file, 'w') as f:
            f.write(default_tickers)
        print(f"✅ Created: {tickers_file}")
        print(f"   Edit this file to customize your tickers!\n")
    else:
        print(f"✅ Found tickers.txt")
    
    # Read tickers from file
    tickers = []
    try:
        with open(tickers_file, 'r') as f:
            lines = f.readlines()
            print(f"📖 Reading {len(lines)} line(s) from tickers.txt...")
            
            for line in lines:
                line = line.strip()
                # Skip empty lines and comments
                if line and not line.startswith('#'):
                    tickers.append(line)
                    print(f"   ✓ Found ticker: {line}")
        
        if not tickers:
            print("⚠️  No tickers found in tickers.txt!")
            print("   (All lines are either empty or comments)")
            print("   Using default tickers: SPY, QQQ, IWM, ES")
            return ['SPY', 'QQQ', 'IWM', 'CME_MINI:ES1!']
        
        print(f"\n✅ Loaded {len(tickers)} ticker(s) from file\n")
        return tickers
    
    except Exception as e:
        print(f"❌ Error reading tickers.txt: {e}")
        print("   Using default tickers: SPY, QQQ, IWM, ES")
        import traceback
        traceback.print_exc()
        return ['SPY', 'QQQ', 'IWM', 'CME_MINI:ES1!']

def get_layout_for_count(count):
    """
    Determine the best grid layout for given number of windows
    Only uses Rectangle's standard shortcuts (halves and quarters)
    Returns (rows, cols, positions_list)
    """
    layouts = {
        1: (1, 1, ['maximize']),
        2: (1, 2, ['left-half', 'right-half']),
        3: (2, 2, ['top-left', 'top-right', 'bottom-left']),
        4: (2, 2, ['top-left', 'top-right', 'bottom-left', 'bottom-right']),
        # For 5-6, use quarters for first 4, then overlap last ones
        5: (2, 2, ['top-left', 'top-right', 'bottom-left', 'bottom-right', 'maximize']),
        6: (2, 2, ['top-left', 'top-right', 'bottom-left', 'bottom-right', 'maximize', 'maximize']),
    }
    
    if count in layouts:
        return layouts[count]
    elif count <= 4:
        return layouts[4]
    else:
        # For more than 6, just use 2x2 grid for first 4, rest maximized
        positions = ['top-left', 'top-right', 'bottom-left', 'bottom-right']
        positions.extend(['maximize'] * (count - 4))
        return (2, 2, positions)

def get_rectangle_shortcut(position):
    """Map position names to Rectangle keyboard shortcuts (standard shortcuts only)"""
    shortcuts = {
        # Basic positions that exist in Rectangle by default
        'maximize': 'keystroke "f" using {control down, option down}',
        'left-half': 'keystroke "left" using {control down, option down}',
        'right-half': 'keystroke "right" using {control down, option down}',
        'top-half': 'keystroke "up" using {control down, option down}',
        'bottom-half': 'keystroke "down" using {control down, option down}',
        
        # Quarters (these exist by default)
        'top-left': 'keystroke "u" using {control down, option down}',
        'top-right': 'keystroke "i" using {control down, option down}',
        'bottom-left': 'keystroke "j" using {control down, option down}',
        'bottom-right': 'keystroke "k" using {control down, option down}',
    }
    
    return shortcuts.get(position, shortcuts['maximize'])

def check_accessibility_permissions():
    """Check if Terminal has accessibility permissions on macOS"""
    test_script = '''
    tell application "System Events"
        return true
    end tell
    '''
    try:
        result = subprocess.run(['osascript', '-e', test_script], 
                              capture_output=True, text=True, timeout=2)
        return result.returncode == 0
    except:
        return False

def activate_window_and_position_macos(window_index, position):
    """Activate Chrome window and send Rectangle shortcut"""
    keystroke_command = get_rectangle_shortcut(position)
    
    applescript = f'''
    tell application "Google Chrome"
        activate
        set index of window {window_index} to 1
    end tell
    delay 0.2
    tell application "System Events"
        tell process "Google Chrome"
            set frontmost to true
            {keystroke_command}
        end tell
    end tell
    '''
    
    try:
        subprocess.run(['osascript', '-e', applescript], check=False)
    except Exception as e:
        print(f"    ⚠️  Could not position window: {e}")

def open_trading_windows():
    """Open Chrome windows with TradingView charts based on tickers.txt"""
    
    os_name = platform.system()
    chrome_path = get_chrome_path()
    
    print("╔════════════════════════════════════════════════════════════╗")
    print("║      TradingView Multi-Window Launcher (Enhanced)         ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print(f"\n💻 Operating System: {os_name}")
    print("")
    
    # Read tickers from file
    tickers = read_tickers_from_file()
    
    ticker_count = len(tickers)
    print(f"🎯 Will open {ticker_count} ticker(s):")
    for i, ticker in enumerate(tickers, 1):
        print(f"   {i}. {ticker}")
    
    # Determine layout
    rows, cols, positions = get_layout_for_count(ticker_count)
    
    if ticker_count == 1:
        print(f"\n📐 Layout: Full screen")
    elif ticker_count == 2:
        print(f"\n📐 Layout: Side by side (50/50)")
    elif ticker_count <= 4:
        print(f"\n📐 Layout: {rows}×{cols} grid (quarters)")
    else:
        print(f"\n📐 Layout: First 4 windows in 2×2 grid")
        print(f"         Windows 5-{ticker_count} will be maximized")
        print(f"         💡 Tip: Use Rectangle manually to arrange remaining windows")
    
    if ticker_count > len(positions):
        print(f"⚠️  Note: Only first {len(positions)} windows will be auto-positioned")
    
    # Check accessibility permissions on macOS
    if os_name == 'Darwin':
        print("\n🔒 Checking macOS accessibility permissions...")
        if not check_accessibility_permissions():
            print("\n❌ PERMISSION ERROR!")
            print("\n🔧 How to fix:")
            print("1. Open System Preferences/Settings")
            print("2. Go to: Privacy & Security → Accessibility")
            print("3. Click the lock icon to make changes")
            print("4. Add your Terminal app to the list")
            print("5. Make sure it's checked/enabled")
            print("6. Restart Terminal and run this script again\n")
            
            response = input("Have you granted permissions? (y/n): ")
            if response.lower() != 'y':
                print("\nExiting. Please grant permissions and try again.")
                sys.exit(1)
        print("✅ Permissions OK")
    
    if os_name != 'Darwin':
        print("\n⚠️  Note: Rectangle is macOS-only.")
        print("On Windows/Linux, windows will open but won't auto-arrange.")
        print("Consider using PowerToys (Windows) for layouts.\n")
    
    # Step 1: Open all windows
    print(f"\n{'═' * 60}")
    print("Step 1: Opening Chrome windows...")
    print('═' * 60)
    
    for i, ticker in enumerate(tickers, 1):
        url = f"https://www.tradingview.com/chart/?symbol={ticker}"
        
        print(f"\n[{i}/{ticker_count}] Opening {ticker}...")
        
        try:
            subprocess.Popen([
                chrome_path,
                '--new-window',
                url
            ])
            time.sleep(1.2)
            
        except FileNotFoundError:
            print(f"\n❌ Error: Chrome not found at {chrome_path}")
            print("Please install Google Chrome and try again.")
            sys.exit(1)
    
    # Step 2: Position windows (macOS only)
    if os_name == 'Darwin':
        print(f"\n{'═' * 60}")
        print("Step 2: Positioning windows with Rectangle...")
        print('═' * 60)
        time.sleep(3.0)  # Wait for TradingView to load
        
        windows_to_position = min(ticker_count, len(positions))
        
        for i in range(windows_to_position):
            window_number = i + 1
            ticker = tickers[i]
            position = positions[i]
            
            print(f"\n[{window_number}/{windows_to_position}] Positioning {ticker} → {position}")
            activate_window_and_position_macos(window_number, position)
            time.sleep(0.4)
        
        # Step 3: Reset charts
        print(f"\n{'═' * 60}")
        print("Step 3: Resetting charts to default view...")
        print('═' * 60)
        time.sleep(0.5)
        
        for i in range(ticker_count):
            window_number = i + 1
            ticker = tickers[i]
            
            print(f"\n[{window_number}/{ticker_count}] Resetting {ticker} chart...")
            
            reset_chart_script = f'''
            tell application "Google Chrome"
                activate
                set index of window {window_number} to 1
            end tell
            delay 0.3
            tell application "System Events"
                tell process "Google Chrome"
                    keystroke "r" using {{option down}}
                end tell
            end tell
            '''
            subprocess.run(['osascript', '-e', reset_chart_script])
            time.sleep(0.4)
        
        # Step 4: Ensure all windows visible
        print(f"\n{'═' * 60}")
        print("Step 4: Making sure all windows are visible...")
        print('═' * 60)
        time.sleep(0.3)
        
        show_all_script = '''
        tell application "Google Chrome"
            activate
            set miniaturized of every window to false
            set visible of every window to true
        end tell
        '''
        subprocess.run(['osascript', '-e', show_all_script])
    
    # Final message
    print(f"\n{'═' * 60}")
    print("✅ COMPLETE!")
    print('═' * 60)
    print(f"\n🎯 Opened {ticker_count} window(s) with tickers:")
    for ticker in tickers:
        print(f"   • {ticker}")
    
    if os_name == 'Darwin':
        print("\n📝 Rectangle shortcuts used:")
        print("   Maximize: Ctrl+Opt+F")
        print("   Halves: Ctrl+Opt+Arrow")
        print("   Quarters: Ctrl+Opt+U (top-left), I (top-right), J (bottom-left), K (bottom-right)")
        if ticker_count > 4:
            print(f"\n💡 For windows 5-{ticker_count}:")
            print("   These are maximized - manually arrange them with Rectangle:")
            print("   • Ctrl+Opt+Arrow for halves")
            print("   • Ctrl+Opt+U/I/J/K for quarters")
        print("\n📊 TradingView shortcuts used:")
        print("   Reset Chart: Option+R (Alt+R)")
    else:
        print("\n💡 Windows arrangement tips:")
        print("   • Use Win+Arrow keys to snap windows")
        print("   • Or install PowerToys FancyZones")
    
    print(f"\n{'─' * 60}")
    print("💡 To change tickers:")
    script_dir = get_script_directory()
    print(f"   Edit: {os.path.join(script_dir, 'tickers.txt')}")
    print("   Then run this script again!")
    print('─' * 60)
    
    if os_name != 'Darwin':
        input("\nPress Enter to exit...")

if __name__ == "__main__":
    try:
        open_trading_windows()
    except KeyboardInterrupt:
        print("\n\n⚠️  Cancelled by user")
        sys.exit(0)
    except Exception as e:
        print(f"\n\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        input("\nPress Enter to exit...")
        sys.exit(1)
