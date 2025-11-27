# 📈 TradingView Multi-Window Launcher (Enhanced)

**Customizable multi-window trading setup with `tickers.txt` configuration!**

Open and auto-arrange ANY number of TradingView charts based on a simple text file.

![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

---

## 🎯 What's New in v2.0

### ✨ **Major Features:**

1. **📝 `tickers.txt` Configuration**
   - Edit a simple text file to set your tickers
   - No need to edit Python code!
   - Comments and examples included

2. **🔢 Dynamic Window Count**
   - Open as many windows as you want (1-20+)
   - Script reads all tickers from file
   - Automatic layout optimization

3. **📐 Smart Layouts**
   - 1 ticker → Full screen
   - 2 tickers → Side by side
   - 3 tickers → 2 top, 1 bottom
   - 4 tickers → 2×2 grid
   - 6 tickers → 2×3 grid
   - 9 tickers → 3×3 grid
   - 10+ → First 9 positioned, rest maximized

4. **🎨 Easy Customization**
   - Change tickers anytime
   - Mix stocks, ETFs, forex, crypto, futures
   - Works with any TradingView symbol

---

## 🚀 Quick Start

### Installation

**macOS:**
```bash
# Download and run installer
./install_macos_enhanced.sh
```

**Windows:**
```cmd
REM Right-click → Run as administrator
install_windows_enhanced.bat
```

### Usage

1. **Edit tickers.txt** (in installation folder)
   ```
   SPY
   QQQ
   AAPL
   TSLA
   ```

2. **Double-click** "TradingView Launcher" on Desktop

3. **Done!** All windows open and arrange automatically

---

## 📝 Using tickers.txt

### Location

**macOS:** `~/TradingViewLauncher/tickers.txt`  
**Windows:** `%USERPROFILE%\TradingViewLauncher\tickers.txt`

### Format

```txt
# Lines starting with # are comments
# One ticker per line

# US Market Overview
SPY
QQQ
IWM
CME_MINI:ES1!

# Tech Stocks
AAPL
MSFT
GOOGL

# Crypto
BTCUSD
ETHUSD
```

### Supported Ticker Formats

| Type | Format | Example |
|------|--------|---------|
| **Stock** | SYMBOL | `AAPL`, `TSLA`, `MSFT` |
| **ETF** | SYMBOL | `SPY`, `QQQ`, `IWM` |
| **Forex** | PAIR | `EURUSD`, `GBPUSD` |
| **Crypto** | SYMBOL | `BTCUSD`, `ETHUSD` |
| **Futures** | CODE! | `ES1!`, `NQ1!`, `GC1!` |
| **With Exchange** | EXCHANGE:SYMBOL | `NASDAQ:AAPL`, `CME_MINI:ES1!` |

### Examples

**Day Trader Setup (4 windows):**
```txt
SPY
QQQ
IWM
ES1!
```

**Tech Focus (6 windows):**
```txt
AAPL
MSFT
GOOGL
NVDA
TSLA
QQQ
```

**Forex Trader (4 windows):**
```txt
EURUSD
GBPUSD
USDJPY
AUDUSD
```

**Crypto Trader (3 windows):**
```txt
BTCUSD
ETHUSD
SOLUSD
```

**Full Market View (9 windows):**
```txt
SPY
QQQ
IWM
DIA
XLF
XLE
XLK
VIX
ES1!
```

---

## 📐 Window Layouts

The script automatically chooses the best layout:

### 1-2 Windows
```
┌─────────┐  or  ┌─────┬─────┐
│    1    │      │  1  │  2  │
└─────────┘      └─────┴─────┘
```

### 3-4 Windows
```
┌─────┬─────┐      ┌─────┬─────┐
│  1  │  2  │      │  1  │  2  │
├─────┴─────┤      ├─────┼─────┤
│     3     │      │  3  │  4  │
└───────────┘      └─────┴─────┘
```

### 6 Windows
```
┌────┬────┬────┐
│ 1  │ 2  │ 3  │
├────┼────┼────┤
│ 4  │ 5  │ 6  │
└────┴────┴────┘
```

### 9 Windows
```
┌───┬───┬───┐
│ 1 │ 2 │ 3 │
├───┼───┼───┤
│ 4 │ 5 │ 6 │
├───┼───┼───┤
│ 7 │ 8 │ 9 │
└───┴───┴───┘
```

---

## ⚙️ Configuration

### Change Tickers

1. Open `tickers.txt` in any text editor
2. Add/remove/edit ticker symbols
3. Save the file
4. Run the launcher again

### Tips for Best Results

✅ **Do:**
- Start with 4-6 tickers
- Use tickers you actively monitor
- Mix different asset types
- Update regularly based on strategy

❌ **Avoid:**
- Too many windows (10+) gets crowded
- Duplicate tickers
- Invalid symbols (check TradingView first)

---

## 🔧 Advanced Usage

### Custom Layouts

While the script auto-selects layouts, you can customize Rectangle shortcuts:

**macOS - Rectangle Preferences:**
- Quarters: `Ctrl+Opt+U/I/J/K`
- Thirds: `Ctrl+Opt+D/E/C` (left), `F/T/V` (center), `G/B` (right)
- Halves: `Ctrl+Opt+←/→/↑/↓`

### Multiple Configurations

Create different ticker files for different strategies:

```bash
# Save different configs
cp tickers.txt tickers_daytrading.txt
cp tickers.txt tickers_longterm.txt
cp tickers.txt tickers_crypto.txt

# Use a specific config
cp tickers_daytrading.txt tickers.txt
./launch.command
```

### Integration with Trading Routine

**Create a morning routine script:**

```bash
#!/bin/bash
# morning_routine.sh

# Update tickers based on watchlist
cp ~/Documents/todays_watchlist.txt ~/TradingViewLauncher/tickers.txt

# Launch charts
cd ~/TradingViewLauncher
./launch.command
```

---

## 📋 Requirements

### macOS
- macOS 10.14+
- Google Chrome
- Python 3 (pre-installed)
- Rectangle (auto-installed)

### Windows
- Windows 10+
- Google Chrome
- Python 3 ([download](https://www.python.org/downloads/))
- *(Optional)* PowerToys

---

## 🆘 Troubleshooting

### "No tickers found in tickers.txt"

**Fix:** 
- Make sure tickers.txt exists in the installation folder
- Check that tickers aren't all commented out (#)
- Verify file isn't empty

### Windows don't arrange (macOS)

**Fix:**
- Make sure Rectangle is running
- Check Rectangle shortcuts match defaults
- Grant accessibility permissions to Terminal

### "Chrome not found"

**Fix:**
- Install Chrome: https://www.google.com/chrome/
- Make sure it's in the default location

### Too many windows overlap

**Fix:**
- Reduce number of tickers to 9 or less
- Use PowerToys FancyZones (Windows) for custom layouts
- Manually arrange windows after opening

---

## 🎓 Examples & Use Cases

### Day Trader
```txt
# Monitor indices and volatility
SPY
QQQ
IWM
VIX
ES1!
NQ1!
```

### Swing Trader
```txt
# Track individual positions
AAPL
TSLA
NVDA
AMD
```

### Forex Trader
```txt
# Major pairs
EURUSD
GBPUSD
USDJPY
AUDUSD
NZDUSD
USDCAD
```

### Crypto Trader
```txt
# Top coins
BTCUSD
ETHUSD
BNBUSD
SOLUSD
XRPUSD
ADAUSD
```

### Options Trader
```txt
# Underlying + VIX + indices
SPY
QQQ
VIX
ES1!
```

---

## 📝 Files Structure

```
TradingViewLauncher/
├── launch_trading_windows.py  # Main script
├── tickers.txt                 # Your configuration ⭐
├── launch.command              # Launcher (macOS)
└── Launch TradingView.bat      # Launcher (Windows)
```
## 💡 Pro Tips

1. **Start Small:** Begin with 4 tickers, expand as needed WORKS BEST!
2. **Group by Strategy:** Create ticker files for different setups
3. **Update Daily:** Adjust tickers based on market conditions
4. **Use Comments:** Document why you're watching each ticker
5. **Keyboard Shortcuts:** Learn Rectangle shortcuts for manual adjustments

---

## 🌟 Support the Project

If this tool helps your trading:
- ⭐ Star the repository
- 📢 Share with trader friends
- 🐛 Report bugs or suggest features
- 💝 Consider contributing improvements

---

## 📜 License

MIT License - Free to use, modify, and distribute!

---

**Happy Trading! 📈📊💰**

*Disclaimer: This tool is for convenience only. Not affiliated with TradingView. Always do your own research and trade responsibly.*

Happy trading, 
Ogi
