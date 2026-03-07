#!/bin/bash
# Daily Research Task - 每日研究任务
# 执行时间: 每天凌晨 3:00 (Asia/Shanghai)
# 数据源: RSS (主要) + Web搜索 (补充)
# 注意: Twitter API 已停用

set -euo pipefail

export PATH="$HOME/.bun/bin:$PATH"
export HOME="/root"

DATE=$(date +%Y-%m-%d)
REPORT_DIR="$HOME/.openclaw/workspace/nova-daily-report"
RESEARCH_DIR="/tmp/research_${DATE//-/}"
mkdir -p "$RESEARCH_DIR"

LOG_FILE="$RESEARCH_DIR/research.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================"
log "开始生成日报: $DATE"
log "========================================"

# 检查依赖
command -v python3 >/dev/null 2>&1 || { log "错误: python3 未安装"; exit 1; }

# 读取 RSS 订阅（主要数据源）
log "正在读取 RSS 订阅源..."

python3 << 'PYEOF'
import feedparser
import sys
from datetime import datetime

output_file = "/tmp/research_" + datetime.now().strftime("%Y%m%d") + "/rss_content.txt"

sources = [
    ("CoinDesk", "https://feeds.feedburner.com/CoinDesk", 5),
    ("OpenAI Blog", "https://openai.com/blog/rss.xml", 3),
    ("Hacker News", "https://news.ycombinator.com/rss", 5),
    ("Decrypt", "https://decrypt.co/feed", 5),
    ("Import AI", "https://importai.substack.com/feed", 3),
]

results = []
results.append(f"=== RSS 采集结果 - {datetime.now().strftime('%Y-%m-%d')} ===\n")

for name, url, count in sources:
    results.append(f"\n--- {name} ---")
    try:
        feed = feedparser.parse(url)
        if not feed.entries:
            results.append(f"  [警告] 未获取到内容")
            continue
        
        for entry in feed.entries[:count]:
            title = entry.get('title', '无标题')
            link = entry.get('link', '无链接')
            results.append(f"• {title}")
            results.append(f"  {link}\n")
    except Exception as e:
        results.append(f"  [错误] {e}")

with open(output_file, 'w', encoding='utf-8') as f:
    f.write('\n'.join(results))

print(f"RSS 内容已保存到: {output_file}")
PYEOF

if [ -f "$RESEARCH_DIR/rss_content.txt" ]; then
    log "RSS 采集完成"
    log "采集内容预览:"
    head -20 "$RESEARCH_DIR/rss_content.txt" | tee -a "$LOG_FILE"
else
    log "警告: RSS 采集可能失败"
fi

# 显示数据来源说明
log ""
log "========================================"
log "数据源使用情况:"
log "  ✅ RSS 订阅 (主要来源)"
log "  ⚠️  Twitter/X (已停用 - 未充值API)"
log "  ⚠️  Agent Reach (需手动调用)"
log "========================================"
log ""
log "下一步操作:"
log "  1. 查看 RSS 内容: cat $RESEARCH_DIR/rss_content.txt"
log "  2. 手动整理并写入日报"
log "  3. 提交到 GitHub"
log ""
log "任务完成 (RSS 采集阶段)"

# 可选：发送通知到 Discord
# 如果需要 Discord 通知，可以在这里添加 webhook 调用
# curl -X POST -H "Content-Type: application/json" \
#   -d '{"content":"📊 日报研究任务完成 - '$DATE'"}' \
#   YOUR_DISCORD_WEBHOOK_URL
