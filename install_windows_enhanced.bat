@echo off
REM ################################################################################
REM TradingView Multi-Window Launcher - Windows Installer (Enhanced v2.0)
REM One-click installation script with tickers.txt support
REM ################################################################################

title TradingView Multi-Window Launcher - Enhanced Installer
color 0B

echo.
echo ================================================================
echo  TradingView Multi-Window Launcher - Installer (Enhanced v2.0)
echo ================================================================
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] This installer needs administrator privileges.
    echo [!] Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

REM Set installation directory
set "INSTALL_DIR=%USERPROFILE%\TradingViewLauncher"

echo [i] Installation directory: %INSTALL_DIR%
echo.

REM ================================================================
REM Step 1: Check Python
REM ================================================================
echo ================================================================
echo Step 1: Checking Python installation...
echo ================================================================

python --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Python found
    python --version
) else (
    echo [X] Python not found!
    echo.
    echo Please install Python 3 from: https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation!
    echo.
    start https://www.python.org/downloads/
    pause
    exit /b 1
)

REM ================================================================
REM Step 2: Check Chrome
REM ================================================================
echo.
echo ================================================================
echo Step 2: Checking Google Chrome installation...
echo ================================================================

if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    echo [OK] Google Chrome found
) else (
    if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
        echo [OK] Google Chrome found
    ) else (
        echo [!] Google Chrome not found!
        echo.
        echo Please install Chrome from: https://www.google.com/chrome/
        start https://www.google.com/chrome/
        echo.
        echo Press any key after installing Chrome...
        pause >nul
    )
)

REM ================================================================
REM Step 3: Create installation directory
REM ================================================================
echo.
echo ================================================================
echo Step 3: Creating installation directory...
echo ================================================================

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
echo [OK] Directory created: %INSTALL_DIR%

REM ================================================================
REM Step 4: Install the Enhanced Python script
REM ================================================================
echo.
echo ================================================================
echo Step 4: Installing TradingView Launcher script (Enhanced v2.0)...
echo ================================================================

REM Create the enhanced Python script with tickers.txt support
powershell -Command "$content = Get-Content '%~f0' | Select-Object -Skip 450; $content -join \"`n\" | Out-File -FilePath '%INSTALL_DIR%\launch_trading_windows.py' -Encoding UTF8"

REM Fallback: If PowerShell method fails, create inline
if not exist "%INSTALL_DIR%\launch_trading_windows.py" (
    echo Creating script using fallback method...
    goto :CREATE_SCRIPT
)

echo [OK] Script installed
goto :AFTER_SCRIPT

:CREATE_SCRIPT
REM This section contains the Python script
REM Due to batch file limitations, we'll create a simpler version
echo Creating simplified launcher script...

(
echo import subprocess, time, sys, platform, os
echo.
echo def get_script_directory^(^):
echo     return os.path.dirname^(os.path.abspath^(__file__^)^)
echo.
echo def get_chrome_path^(^):
echo     paths = ['C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
echo              'C:\\Program Files ^(x86^)\\Google\\Chrome\\Application\\chrome.exe']
echo     for path in paths:
echo         if os.path.exists^(path^): return path
echo     return 'chrome'
echo.
echo def read_tickers^(^):
echo     tickers_file = os.path.join^(get_script_directory^(^), 'tickers.txt'^)
echo     if not os.path.exists^(tickers_file^):
echo         with open^(tickers_file, 'w'^) as f:
echo             f.write^('# TradingView Tickers\n# One per line\n\nSPY\nQQQ\nIWM\nCME_MINI:ES1!\n'^)
echo         print^(f'Created: {tickers_file}'^)
echo     tickers = []
echo     with open^(tickers_file^) as f:
echo         for line in f:
echo             line = line.strip^(^)
echo             if line and not line.startswith^('#'^): tickers.append^(line^)
echo     return tickers if tickers else ['SPY', 'QQQ', 'IWM', 'CME_MINI:ES1!']
echo.
echo def main^(^):
echo     print^('TradingView Multi-Window Launcher\n'^)
echo     tickers = read_tickers^(^)
echo     print^(f'Opening {len^(tickers^)} window^(s^)...'^)
echo     chrome = get_chrome_path^(^)
echo     for i, ticker in enumerate^(tickers, 1^):
echo         print^(f'[{i}/{len^(tickers^)}] {ticker}'^)
echo         url = f'https://www.tradingview.com/chart/?symbol={ticker}'
echo         subprocess.Popen^([chrome, '--new-window', url]^)
echo         time.sleep^(1.5^)
echo     print^('\nDone! Use Win+Arrow to arrange windows.'^)
echo     print^(f'\nEdit tickers.txt to customize: {os.path.join^(get_script_directory^(^), "tickers.txt"^)}'^)
echo     input^('\nPress Enter to exit...'^)
echo.
echo if __name__ == '__main__': main^(^)
) > "%INSTALL_DIR%\launch_trading_windows.py"

echo [OK] Script created

:AFTER_SCRIPT

REM ================================================================
REM Step 5: Create default tickers.txt
REM ================================================================
echo.
echo ================================================================
echo Step 5: Creating tickers configuration file...
echo ================================================================

(
echo # TradingView Multi-Window Launcher - Tickers Configuration
echo # ===========================================================
echo #
echo # HOW TO USE:
echo # -----------
echo # * Add one ticker per line
echo # * Lines starting with # are comments ^(ignored^)
echo # * Remove # to activate a ticker
echo # * The script will open one window per ticker
echo #
echo # SUPPORTED LAYOUTS:
echo # ------------------
echo # * 1 ticker  = Full screen
echo # * 2 tickers = Side by side ^(50/50^)
echo # * 4 tickers = 2x2 grid ^(quarters^)
echo # * 6 tickers = 2x3 grid ^(sixths^)
echo # * 9 tickers = 3x3 grid
echo #
echo # TICKER FORMATS:
echo # ---------------
echo # * Stock: AAPL, TSLA, MSFT
echo # * ETF: SPY, QQQ, IWM
echo # * Forex: EURUSD, GBPUSD
echo # * Crypto: BTCUSD, ETHUSD
echo # * Futures: ES1!, NQ1!, GC1!, CL1!
echo # * With exchange: NASDAQ:AAPL, CME_MINI:ES1!
echo #
echo # ===========================================================
echo.
echo # DEFAULT TICKERS ^(US Market Overview^)
echo SPY
echo QQQ
echo IWM
echo CME_MINI:ES1!
echo.
echo # POPULAR STOCKS ^(Uncomment to use^)
echo # AAPL
echo # TSLA
echo # MSFT
echo # GOOGL
echo # NVDA
echo.
echo # FOREX PAIRS ^(Uncomment to use^)
echo # EURUSD
echo # GBPUSD
echo # USDJPY
echo.
echo # CRYPTOCURRENCY ^(Uncomment to use^)
echo # BTCUSD
echo # ETHUSD
echo.
echo # COMMODITIES FUTURES ^(Uncomment to use^)
echo # GC1!
echo # CL1!
echo.
echo # ===========================================================
echo # To change tickers: Edit this file and run the launcher again
echo # ===========================================================
) > "%INSTALL_DIR%\tickers.txt"

echo [OK] tickers.txt created with default configuration
echo.
echo     You can edit this file to customize your tickers!
echo     Location: %INSTALL_DIR%\tickers.txt

REM ================================================================
REM Step 6: Create launcher batch file
REM ================================================================
echo.
echo ================================================================
echo Step 6: Creating launcher...
echo ================================================================

(
echo @echo off
echo title TradingView Multi-Window Launcher
echo cd /d "%%~dp0"
echo python launch_trading_windows.py
) > "%INSTALL_DIR%\Launch TradingView.bat"

echo [OK] Launcher created

REM ================================================================
REM Step 7: Create Desktop shortcut
REM ================================================================
echo.
echo ================================================================
echo Step 7: Creating Desktop shortcut...
echo ================================================================

REM Create VBS script to make shortcut
set "SHORTCUT_VBS=%TEMP%\CreateShortcut.vbs"
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%USERPROFILE%\Desktop\TradingView Launcher.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\Launch TradingView.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Launch TradingView Multi-Window with Custom Tickers"
echo oLink.IconLocation = "C:\Program Files\Google\Chrome\Application\chrome.exe,0"
echo oLink.Save
) > "%SHORTCUT_VBS%"

cscript //nologo "%SHORTCUT_VBS%"
del "%SHORTCUT_VBS%"

echo [OK] Desktop shortcut created

REM ================================================================
REM Step 8: Create quick edit shortcut for tickers.txt
REM ================================================================
echo.
echo ================================================================
echo Step 8: Creating tickers.txt editor shortcut...
echo ================================================================

set "EDIT_VBS=%TEMP%\CreateEditShortcut.vbs"
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%USERPROFILE%\Desktop\Edit Tickers.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\tickers.txt"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Edit TradingView Tickers Configuration"
echo oLink.Save
) > "%EDIT_VBS%"

cscript //nologo "%EDIT_VBS%"
del "%EDIT_VBS%"

echo [OK] Tickers editor shortcut created on Desktop

REM ================================================================
REM Step 9: Optional PowerToys installation
REM ================================================================
echo.
echo ================================================================
echo Step 9: PowerToys ^(Optional - Recommended^)
echo ================================================================
echo.
echo PowerToys includes FancyZones for advanced window management.
echo This is HIGHLY RECOMMENDED for automatic window arrangement!
echo.
echo Would you like to open the PowerToys download page?
echo.
choice /C YN /M "Open PowerToys download page"

if %errorLevel% equ 1 (
    start https://github.com/microsoft/PowerToys/releases/latest
    echo.
    echo [i] Opening PowerToys download page...
    echo [i] After installing:
    echo     1. Press Win+Shift+` to open FancyZones editor
    echo     2. Create a 2x2 or 3x3 grid layout
    echo     3. Drag windows to zones to arrange them
)

REM ================================================================
REM Step 10: Show README
REM ================================================================
echo.
echo ================================================================
echo Step 10: Creating README file...
echo ================================================================

(
echo TradingView Multi-Window Launcher - README
echo ==========================================
echo.
echo INSTALLATION COMPLETE!
echo.
echo HOW TO USE:
echo -----------
echo 1. Edit your tickers:
echo    * Double-click "Edit Tickers" on your Desktop
echo    * Or open: %INSTALL_DIR%\tickers.txt
echo    * Add one ticker per line
echo    * Save the file
echo.
echo 2. Launch the windows:
echo    * Double-click "TradingView Launcher" on your Desktop
echo    * Wait for all windows to open
echo.
echo 3. Arrange windows:
echo    * Use Win+Arrow keys to snap windows:
echo      - Win+Left then Win+Up = Top Left
echo      - Win+Right then Win+Up = Top Right
echo      - Win+Left then Win+Down = Bottom Left
echo      - Win+Right then Win+Down = Bottom Right
echo.
echo    * Or use PowerToys FancyZones for automatic layouts
echo.
echo TICKER EXAMPLES:
echo ----------------
echo Stocks:  AAPL, TSLA, MSFT
echo ETFs:    SPY, QQQ, IWM
echo Forex:   EURUSD, GBPUSD
echo Crypto:  BTCUSD, ETHUSD
echo Futures: ES1!, NQ1!, GC1!
echo.
echo TIPS:
echo -----
echo * Start with 4-6 tickers for best results
echo * Install PowerToys for easier window management
echo * Update tickers.txt anytime and run again
echo * Use comments in tickers.txt with #
echo.
echo SUPPORT:
echo --------
echo Installation location: %INSTALL_DIR%
echo Tickers file: %INSTALL_DIR%\tickers.txt
echo.
echo For issues, check:
echo * Python is installed and in PATH
echo * Chrome is installed
echo * tickers.txt has valid symbols
echo.
echo Happy Trading!
) > "%INSTALL_DIR%\README.txt"

echo [OK] README.txt created

REM ================================================================
REM Installation Complete
REM ================================================================
echo.
echo ================================================================
echo                   INSTALLATION COMPLETE!
echo ================================================================
echo.
echo [OK] TradingView Multi-Window Launcher installed successfully!
echo.
echo Installation location: %INSTALL_DIR%
echo.
echo Desktop shortcuts created:
echo   * TradingView Launcher - Run the launcher
echo   * Edit Tickers - Edit your ticker list
echo.
echo ================================================================
echo QUICK START:
echo ================================================================
echo.
echo 1. CUSTOMIZE YOUR TICKERS:
echo    Double-click "Edit Tickers" on your Desktop
echo    Add your favorite tickers ^(one per line^)
echo    Save and close
echo.
echo 2. LAUNCH:
echo    Double-click "TradingView Launcher" on your Desktop
echo.
echo 3. ARRANGE ^(choose one^):
echo    Option A: Use Win+Arrow keys to snap windows
echo    Option B: Install PowerToys FancyZones for auto-arrangement
echo.
echo ================================================================
echo EXAMPLE SETUPS:
echo ================================================================
echo.
echo Day Trader ^(4 tickers^):        Tech Focus ^(6 tickers^):
echo   SPY                           AAPL
echo   QQQ                           MSFT
echo   IWM                           GOOGL
echo   ES1!                          NVDA
echo                                 TSLA
echo                                 QQQ
echo.
echo Forex ^(4 tickers^):            Crypto ^(3 tickers^):
echo   EURUSD                        BTCUSD
echo   GBPUSD                        ETHUSD
echo   USDJPY                        SOLUSD
echo   AUDUSD
echo.
echo ================================================================
echo WINDOW ARRANGEMENT TIPS:
echo ================================================================
echo.
echo Manual ^(using Win+Arrow keys^):
echo   Top Left:     Win+Left, then Win+Up
echo   Top Right:    Win+Right, then Win+Up
echo   Bottom Left:  Win+Left, then Win+Down
echo   Bottom Right: Win+Right, then Win+Down
echo.
echo Automatic ^(using PowerToys FancyZones^):
echo   1. Install PowerToys from: https://github.com/microsoft/PowerToys
echo   2. Press Win+Shift+` to open FancyZones editor
echo   3. Create a 2x2, 2x3, or 3x3 grid layout
echo   4. Hold Shift and drag windows to zones
echo   5. Windows snap automatically!
echo.
echo ================================================================
echo.
echo Press any key to finish installation...
pause >nul

echo.
echo Opening README and tickers.txt for you...
timeout /t 2 >nul

start notepad "%INSTALL_DIR%\README.txt"
timeout /t 1 >nul
start notepad "%INSTALL_DIR%\tickers.txt"

echo.
echo [OK] Setup complete! Enjoy your trading setup!
echo.
timeout /t 3 >nul

exit /b 0
