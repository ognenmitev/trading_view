# 🚀 Quick Start Guide (Enhanced Version)

## What's Different in v2.0?

✨ **Edit `tickers.txt` instead of Python code!**  
✨ **Open ANY number of windows (not just 4)**  
✨ **Automatic layout optimization**

---

## Installation (2 minutes)

### macOS
```bash
chmod +x install_macos_enhanced.sh
./install_macos_enhanced.sh
```

### Windows
```cmd
Right-click install_windows_enhanced.bat
→ Run as administrator
```

---

## Usage (3 steps)

### 1️⃣ Edit Your Tickers

**Location:**
- macOS: `~/TradingViewLauncher/tickers.txt`
- Windows: `%USERPROFILE%\TradingViewLauncher\tickers.txt`

**Example:**
```txt
# My watchlist
SPY
QQQ
AAPL
TSLA
NVDA
BTCUSD
```

### 2️⃣ Run the Launcher

Double-click **"TradingView Launcher"** on your Desktop

### 3️⃣ Done!

All windows open and arrange automatically! 🎉

---

## Ticker Format Examples

```txt
# Stocks
AAPL
TSLA
MSFT

# ETFs  
SPY
QQQ
IWM

# Forex
EURUSD
GBPUSD

# Crypto
BTCUSD
ETHUSD

# Futures
ES1!
GC1!

# With Exchange
NASDAQ:AAPL
CME_MINI:ES1!
```

---

## Recommended Setups

### Beginner (4 tickers)
```txt
SPY
QQQ
IWM
ES1!
```

### Day Trader (6 tickers)
```txt
SPY
QQQ
IWM
VIX
ES1!
NQ1!
```

### Full Monitor (9 tickers)
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

## Common Questions

**Q: How many windows can I open?**  
A: Technically unlimited, but 4-9 is recommended for usability.

**Q: How do I change tickers?**  
A: Edit `tickers.txt`, save, and run launcher again.

**Q: Can I use any ticker?**  
A: Yes! Any symbol that works on TradingView.

**Q: What if I want different layouts?**  
A: The script auto-selects the best layout for your ticker count.

---

## Layout Guide

- 1-2 tickers → Halves or full screen
- 3-4 tickers → Quarters (2×2)
- 5-6 tickers → Sixths (2×3)
- 7-9 tickers → Ninths (3×3)
- 10+ tickers → First 9 positioned, rest maximized

---

## Troubleshooting

### Issue: Windows don't arrange (macOS)
**Fix:** Rectangle isn't running or needs permissions
- Open Rectangle from Applications
- Grant accessibility permissions

### Issue: Script can't find tickers.txt
**Fix:** File is in wrong location
- Make sure it's in same folder as the script
- Or let script create default file on first run

### Issue: Invalid ticker symbols
**Fix:** Check symbols on TradingView first
- Go to TradingView.com
- Search for your symbol
- Use the exact format shown

---

## Pro Tips

💡 Keep tickers.txt organized with comments  
💡 Start with 4-6 tickers, expand gradually  
💡 Save backup configs for different strategies  
💡 Update tickers based on daily watchlist  
💡 Use keyboard shortcuts for fine-tuning

---

## Next Steps

1. ✅ Install the launcher
2. ✅ Edit tickers.txt with your watchlist
3. ✅ Run and enjoy auto-arranged charts!
4. 📚 Read full README for advanced features

---

**Need more help?** See README_ENHANCED.md for complete documentation!

**Happy Trading! 📈**
