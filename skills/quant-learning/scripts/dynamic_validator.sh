#!/usr/bin/bash
# Dynamic Top 10 Strategy Validator
# 每次心跳触发时，动态获取最新最活跃交易对并验证策略

set -e

DATE=$(date '+%Y-%m-%d %H:%M:%S')
LOG_DIR="/root/.openclaw/workspace/skills/quant-learning/logs"
RESULT_DIR="/root/.openclaw/workspace/skills/quant-learning/results"
mkdir -p "$LOG_DIR" "$RESULT_DIR"

LOG_FILE="$LOG_DIR/dynamic-$(date +%Y%m%d).log"
RESULT_FILE="$RESULT_DIR/dynamic-$(date +%Y%m%d-%H%M%S).json"

echo "[$DATE] ====== 动态Top10策略验证开始 ======" | tee -a "$LOG_FILE"

# 1. 获取最新最活跃的10个交易对
echo "[$DATE] 1. 获取最新Top10交易对..." | tee -a "$LOG_FILE"

python3 << 'PYEOF'
import ccxt
import json
from datetime import datetime

exchange = ccxt.binance({'options': {'defaultType': 'future'}})

# 获取24小时交易量
tickers = exchange.fetch_tickers()

usdt_pairs = []
for symbol, ticker in tickers.items():
    if '/USDT' in symbol and ':_' not in symbol:
        volume = ticker.get('quoteVolume', 0)
        if volume > 0:
            usdt_pairs.append((symbol.replace(':USDT', ''), volume))

# Top 10
top10 = sorted(usdt_pairs, key=lambda x: x[1], reverse=True)[:10]

print("最新Top10交易对:")
for i, (symbol, vol) in enumerate(top10, 1):
    print(f"  {i}. {symbol:10s} - ${vol:,.0f}")

# 保存
with open('/tmp/dynamic_top10.json', 'w') as f:
    json.dump({
        'timestamp': datetime.now().isoformat(),
        'pairs': [{'symbol': s, 'volume': v} for s, v in top10]
    }, f, indent=2)

print(f"\n交易对列表已保存: /tmp/dynamic_top10.json")
PYEOF

# 2. 下载最新K线数据
echo "[$DATE] 2. 下载最新K线数据..." | tee -a "$LOG_FILE"

python3 << 'PYEOF'
import ccxt
import pandas as pd
import json
from datetime import datetime, timedelta
import time

# 读取交易对
with open('/tmp/dynamic_top10.json', 'r') as f:
    data = json.load(f)
    symbols = [p['symbol'] for p in data['pairs']]

exchange = ccxt.binance({'options': {'defaultType': 'future'}})

downloaded = []
for symbol in symbols:
    try:
        # 只下载最近7天数据 (快速验证)
        since = exchange.parse8601((datetime.now() - timedelta(days=7)).isoformat())
        ohlcv = exchange.fetch_ohlcv(symbol, '1h', since=since)
        
        if len(ohlcv) > 100:
            df = pd.DataFrame(ohlcv, columns=['timestamp', 'open', 'high', 'low', 'close', 'volume'])
            df['timestamp'] = pd.to_datetime(df['timestamp'], unit='ms')
            df.set_index('timestamp', inplace=True)
            
            output_file = f'/tmp/dynamic_{symbol.replace("/", "_")}_1h.csv'
            df.to_csv(output_file)
            downloaded.append(symbol)
            print(f"✅ {symbol}: {len(df)} 条数据")
        else:
            print(f"⚠️ {symbol}: 数据不足")
            
    except Exception as e:
        print(f"❌ {symbol}: {e}")
    
    time.sleep(0.2)

# 保存成功列表
with open('/tmp/dynamic_downloaded.json', 'w') as f:
    json.dump({'symbols': downloaded}, f)

print(f"\n成功下载: {len(downloaded)}/{len(symbols)} 个交易对")
PYEOF

# 3. 运行策略验证
echo "[$DATE] 3. 运行策略回测验证..." | tee -a "$LOG_FILE"

python3 << 'PYEOF'
import vectorbt as vbt
import pandas as pd
import numpy as np
import talib
import json
import os
from datetime import datetime

# 读取下载成功的交易对
with open('/tmp/dynamic_downloaded.json', 'r') as f:
    symbols = json.load(f)['symbols']

grid_spacing = 0.012
tp_mult = 1.2

results = []

print("\n策略回测结果:")
print("="*70)

for symbol in symbols:
    try:
        csv_file = f'/tmp/dynamic_{symbol.replace("/", "_")}_1h.csv'
        if not os.path.exists(csv_file):
            continue
            
        df = pd.read_csv(csv_file, index_col='timestamp', parse_dates=True)
        
        if len(df) < 50:
            continue
        
        close = df['close']
        high = df['high']
        low = df['low']
        
        # 指标
        ema20 = close.ewm(span=20).mean()
        ema50 = close.ewm(span=50).mean()
        trend_ok = close > ema50
        
        atr = (high - low).rolling(14).mean()
        atr_pct = atr / close * 100
        
        # 信号
        entries = pd.Series(False, index=close.index)
        exits = pd.Series(False, index=close.index)
        
        position_open = False
        entry_price = 0
        
        for i in range(20, len(close)):
            current_price = close.iloc[i]
            current_atr_pct = atr_pct.iloc[i]
            
            if pd.isna(current_atr_pct):
                continue
            
            dynamic_spacing = np.clip(grid_spacing * (current_atr_pct / 2), 0.008, 0.025)
            
            if not trend_ok.iloc[i]:
                continue
            
            grid_center = ema20.iloc[i]
            grid_lower = grid_center * (1 - dynamic_spacing * 4)
            grid_upper = grid_center * (1 + dynamic_spacing * 4)
            grids = np.linspace(grid_lower, grid_upper, 11)
            
            if not position_open:
                for grid in grids:
                    if current_price <= grid * 1.003 and current_price >= grid * 0.997:
                        entries.iloc[i] = True
                        position_open = True
                        entry_price = current_price
                        break
            else:
                profit_pct = (current_price - entry_price) / entry_price
                if profit_pct >= dynamic_spacing * tp_mult:
                    exits.iloc[i] = True
                    position_open = False
        
        # 回测
        portfolio = vbt.Portfolio.from_signals(
            close=close, entries=entries, exits=exits,
            init_cash=1000, fees=0.001, freq='1h'
        )
        
        trades = portfolio.trades.count()
        if trades > 0:
            win_rate = portfolio.trades.win_rate() * 100
            returns = portfolio.total_return() * 100
            
            results.append({
                'symbol': symbol,
                'trades': int(trades),
                'win_rate': float(win_rate),
                'returns': float(returns)
            })
            
            status = '✅' if win_rate >= 80 else '🟡' if win_rate >= 70 else '❌'
            print(f"{status} {symbol:10s}: {trades:2d}笔, 胜率{win_rate:5.1f}%, 收益{returns:6.1f}%")
        else:
            print(f"⚠️ {symbol:10s}: 无交易")
            
    except Exception as e:
        print(f"❌ {symbol:10s}: 错误 - {str(e)[:30]}")

print("="*70)

# 汇总
if results:
    total_trades = sum(r['trades'] for r in results)
    avg_win_rate = np.mean([r['win_rate'] for r in results])
    qualified = [r for r in results if r['win_rate'] >= 80]
    
    print(f"\n汇总:")
    print(f"  验证币种: {len(results)}")
    print(f"  总交易: {total_trades} 次")
    print(f"  平均胜率: {avg_win_rate:.2f}%")
    print(f"  达标币种: {len(qualified)}/{len(results)} (胜率≥80%)")
    
    if avg_win_rate >= 80:
        print(f"\n✅✅✅ 策略验证通过! 平均胜率 {avg_win_rate:.2f}% >= 80%")
    else:
        print(f"\n⚠️  策略需要优化，胜率 {avg_win_rate:.2f}% < 80%")
    
    # 保存结果
    result_data = {
        'timestamp': datetime.now().isoformat(),
        'summary': {
            'pairs_tested': len(results),
            'total_trades': total_trades,
            'avg_win_rate': float(avg_win_rate),
            'qualified_pairs': len(qualified)
        },
        'details': results
    }
    
    with open('/tmp/dynamic_result.json', 'w') as f:
        json.dump(result_data, f, indent=2)
    
    print(f"\n结果已保存: /tmp/dynamic_result.json")
else:
    print("❌ 没有有效的回测结果")
PYEOF

# 4. 记录结果
echo "[$DATE] 4. 保存验证结果..." | tee -a "$LOG_FILE"

if [ -f /tmp/dynamic_result.json ]; then
    cp /tmp/dynamic_result.json "$RESULT_FILE"
    echo "[$DATE] 结果已保存: $RESULT_FILE" | tee -a "$LOG_FILE"
fi

echo "[$DATE] ====== 动态Top10策略验证完成 ======" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
