# Ogi's Levels - TradingView Pine Script Indicator

A comprehensive technical analysis indicator for TradingView that combines support/resistance levels, stop loss/take profit calculations, trend detection, and key price levels to help traders make informed decisions.

## Features

### 1. Support & Resistance Levels
- Automatically detects pivot highs and lows based on configurable strength
- Displays support and resistance levels as colored boxes
- Shows up to 8 levels (configurable)
- Each level is labeled (S1, S2, S3 for support; R1, R2, R3 for resistance)
- Visual alerts when price approaches key levels

### 2. Stop Loss & Take Profit Lines
- **Long Position Lines:**
  - Stop Loss (red solid line) - calculated using ATR multiplier
  - Take Profit 1 (green dashed line) - based on risk:reward ratio
  - Take Profit 2 (lime dotted line) - extended profit target
  
- **Short Position Lines:**
  - Stop Loss (red solid line)
  - Take Profit 1 (green dashed line)
  - Take Profit 2 (lime dotted line)

- All levels display exact price values in labels

### 3. Trend Indicator
- Displays current market trend in the upper right corner
- Three states: **UPTREND ▲**, **DOWNTREND ▼**, **SIDEWAYS ●**
- Based on multiple moving averages (50 and 200 SMA by default)
- Color-coded: Green (uptrend), Red (downtrend), Orange (sideways)

### 4. Yesterday's Levels (Purple Lines)
- **Yesterday's High (Y-HH):** Purple line showing previous day's highest point
- **Yesterday's Low (Y-LL):** Purple line showing previous day's lowest point
- Useful for identifying key support/resistance from prior trading session

### 5. All-Time High (ATH)
- Purple dashed line showing the highest price ever reached
- Helps identify breakout opportunities and psychological resistance levels

### 6. Current Price Line
- White horizontal line showing current price
- Labeled with exact price value for quick reference

## Input Parameters

### Support & Resistance
- **Pivot Strength** (3-30, default: 10) - Sensitivity for detecting pivots
- **Number of Levels** (1-8, default: 3) - How many S/R levels to display
- **Box Extension** (10-100, default: 50) - How far to project levels into future
- **Box Height** (0.1-1.0 ATR, default: 0.3) - Visual thickness of S/R boxes

### Stop Loss & Take Profit
- **Show SL/TP Lines** (toggle)
- **SL ATR Multiplier** (0.5-5.0, default: 2.0) - Stop loss distance
- **TP1 Risk:Reward** (1.0-5.0, default: 2.0) - First profit target ratio
- **TP2 Risk:Reward** (1.5-8.0, default: 3.0) - Second profit target ratio

### Trend Detection
- **Show Trend Indicator** (toggle)
- **Fast MA Period** (10-100, default: 50)
- **Slow MA Period** (50-300, default: 200)

### Yesterday's Levels & ATH
- **Show Yesterday's HH/HL** (toggle)
- **Show All-Time High** (toggle)
- **Purple Line Color** (customizable)

### Colors
- Customizable colors for all elements:
  - Support levels
  - Resistance levels
  - Stop loss lines
  - Take profit lines
  - Purple lines (yesterday's levels & ATH)

## Visual Alerts

The indicator provides visual feedback when:
- Price approaches support levels (green background highlight)
- Price approaches resistance levels (red background highlight)

## Alert Conditions

Set up TradingView alerts for:
- Price reaching support level
- Price reaching resistance level
- Long stop loss hit
- Long take profit 1 hit
- Short stop loss hit
- Short take profit 1 hit

## How to Use

1. **Copy the Pine Script code** to TradingView's Pine Editor
2. **Click "Add to Chart"** to apply the indicator
3. **Customize settings** based on your trading style and timeframe
4. **Set up alerts** for key levels you want to monitor
5. **Use the levels** to plan entries, exits, and risk management

## Trading Strategy Tips

- **Trend Following:** Use the trend indicator to trade in the direction of the overall trend
- **Support/Resistance Bounces:** Look for entries when price reaches S/R levels
- **Breakouts:** Watch for price breaking through resistance or ATH
- **Risk Management:** Use the SL/TP lines to plan your trades with proper risk:reward ratios
- **Yesterday's Levels:** Previous day's high/low often act as intraday support/resistance

## Technical Details

- **Version:** Pine Script v6
- **Overlay:** Yes (draws on price chart)
- **Max Boxes:** 100
- **Max Lines:** 100
- **Calculations:** Uses ATR (14-period) for dynamic level sizing

## License

This Pine Script® code is subject to the terms of the Mozilla Public License 2.0
https://mozilla.org/MPL/2.0/

## Author

© ognenmitev

## Disclaimer

This indicator is for educational and informational purposes only. It should not be considered financial advice. Always conduct your own research and risk management before making trading decisions.
