import ccxt
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import json

print("=== 实时信号检查 ===")
print(f"时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print()

# 初始化
exchange = ccxt.binance({'options': {'defaultType': 'future'}})

# 监控币种
symbols = {
    'BNB/USDT': {'ema_fast': 20, 'ema_slow': 50},
    'SOL/USDT': {'ema_fast': 20, 'ema_slow': 50},
    'ETH/USDT': {'ema_fast': 20, 'ema_slow': 50},
}

signals = []

for symbol, params in symbols.items():
    try:
        # 获取最近100根K线
        since = exchange.parse8601((datetime.now() - timedelta(hours=100)).isoformat())
        ohlcv = exchange.fetch_ohlcv(symbol, '1h', since=since)
        
        if len(ohlcv) < 50:
            continue
        
        # 计算指标
        df = pd.DataFrame(ohlcv, columns=['timestamp', 'open', 'high', 'low', 'close', 'volume'])
        close = df['close']
        high = df['high']
        low = df['low']
        
        ema20 = close.ewm(span=20).mean()
        ema50 = close.ewm(span=50).mean()
        
        current_price = close.iloc[-1]
        current_ema20 = ema20.iloc[-1]
        current_ema50 = ema50.iloc[-1]
        
        # 趋势判断
        trend_up = current_price > current_ema50
        
        # 信号判断
        atr = (high.iloc[-14:] - low.iloc[-14:]).mean()
        atr_pct = atr / current_price * 100
        spacing = max(0.008, min(0.025, 0.012 * (atr_pct / 2)))
        
        # 计算网格
        grid_center = current_ema20
        grid_lower = grid_center * (1 - spacing * 4)
        grids = np.linspace(grid_lower, grid_center * (1 + spacing * 4), 11)
        
        # 检查是否在买入区域
        in_buy_zone = any(current_price <= g * 1.003 and current_price >= g * 0.997 
                         for g in grids if g < grid_center)
        
        signal = "买入" if (trend_up and in_buy_zone) else "观望"
        
        signals.append({
            'symbol': symbol,
            'price': current_price,
            'ema20': current_ema20,
            'ema50': current_ema50,
            'trend': 'UP' if trend_up else 'DOWN',
            'signal': signal
        })
        
        print(f"{symbol}:")
        print(f"  价格: ${current_price:,.2f}")
        print(f"  EMA20: ${current_ema20:,.2f}")
        print(f"  趋势: {'UP' if trend_up else 'DOWN'}")
        print(f"  信号: {signal}")
        print()
        
    except Exception as e:
        print(f"{symbol}: 错误 - {e}")

# 保存信号
with open('/tmp/latest_signals.json', 'w') as f:
    json.dump({
        'timestamp': datetime.now().isoformat(),
        'signals': signals
    }, f, indent=2)

print(f"信号已保存到: /tmp/latest_signals.json")
