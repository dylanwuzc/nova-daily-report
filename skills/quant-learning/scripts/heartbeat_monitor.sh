#!/bin/bash
# Heartbeat Quant Monitor - 量化策略心跳监控
# 每次心跳触发时执行

set -e

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Heartbeat触发 - 量化策略监控"

# 工作目录
WORK_DIR="/root/.openclaw/workspace/skills/quant-learning"
LOG_FILE="$WORK_DIR/logs/heartbeat-$(date +%Y%m%d).log"
mkdir -p "$WORK_DIR/logs"

echo "[$DATE] ====== 心跳检查开始 ======" | tee -a "$LOG_FILE"

# 1. 拉取最新K线数据
echo "[$DATE] 1. 拉取最新K线数据..." | tee -a "$LOG_FILE"
python3 << 'PYEOF'
import ccxt
import pandas as pd
from datetime import datetime, timedelta

exchange = ccxt.binance({'options': {'defaultType': 'future'}})

# 监控的币种
symbols = ['BNB/USDT', 'SOL/USDT', 'ETH/USDT', 'LINK/USDT', 'AVAX/USDT']

print("最新数据拉取:")
for symbol in symbols:
    try:
        # 获取最近24小时数据
        since = exchange.parse8601((datetime.now() - timedelta(hours=24)).isoformat())
        ohlcv = exchange.fetch_ohlcv(symbol, '1h', since=since)
        
        if len(ohlcv) > 0:
            latest = ohlcv[-1]
            price = latest[4]
            volume = latest[5]
            print(f"  {symbol}: ${price:,.2f}, Vol: {volume:.2f}")
    except Exception as e:
        print(f"  {symbol}: 错误 - {e}")
PYEOF

# 2. 策略信号检查
echo "[$DATE] 2. 策略信号检查..." | tee -a "$LOG_FILE"
python3 "$WORK_DIR/scripts/signal_check.py" 2>&1 | tee -a "$LOG_FILE" || echo "信号检查脚本待创建"

# 3. 记录状态
echo "[$DATE] 3. 更新监控日志..." | tee -a "$LOG_FILE"
cat > "$WORK_DIR/status.json" << EOF
{
  "last_check": "$(date -Iseconds)",
  "status": "active",
  "pairs": ["BNB", "SOL", "ETH", "LINK", "AVAX"],
  "target_win_rate": 80,
  "target_trades": 50
}
EOF

echo "[$DATE] ====== 心跳检查完成 ======" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
