#!/usr/bin/env python3
"""Check heartbeat tasks due dates"""
import json
from datetime import datetime, timedelta

with open('/root/.openclaw/workspace/memory/heartbeat-state.json') as f:
    state = json.load(f)

with open('/root/.openclaw/workspace/HEARTBEAT.md') as f:
    content = f.read()

print("=== HEARTBEAT 任务状态 ===\n")

today = datetime.now().date()

for task, last_date_str in state['lastChecks'].items():
    last_date = datetime.strptime(last_date_str, '%Y-%m-%d').date()
    days_since = (today - last_date).days
    
    # 确定阈值
    if task in ['memory_maintenance', 'backup']:
        threshold = 3
    elif task == 'journal':
        threshold = 2
    elif task == 'system':
        threshold = 7
    else:
        threshold = 3
    
    status = "⚠️  到期" if days_since >= threshold else "✅ 正常"
    print(f"{status} {task}: 已 {days_since} 天 (阈值: {threshold}天)")

print("\n查看详细说明: cat ~/.openclaw/workspace/HEARTBEAT.md")
