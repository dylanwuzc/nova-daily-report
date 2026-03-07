# HEARTBEAT.md

## 状态追踪
查看上次检查时间：
```bash
cat ~/.openclaw/workspace/memory/heartbeat-state.json
```

## Checklist (pick what's relevant each beat, don't do all every time)

### Memory Maintenance (every 3 days)
**检查**: 查看 `heartbeat-state.json` 中的 `memory_maintenance`
**如果 ≥3 天未执行**:
1. Scan recent memory/YYYY-MM-DD.md files
2. Update MEMORY.md with significant decisions, lessons, insights
3. Remove outdated entries from MEMORY.md
4. Verify key updates are retrievable via memory_search
5. Update the maintenance date at top of MEMORY.md
6. **更新**: `heartbeat-state.json` 中的日期

### Discord (every beat)
- Check for unread mentions or DMs that need a response

### System (every 7 days)
**检查**: 查看 `heartbeat-state.json` 中的 `system`
**如果 ≥7 天未执行**:
- Quick check: disk space, gateway health (openclaw health)
- Note any issues in today's memory file
- **更新**: `heartbeat-state.json` 中的日期

### Nova 手记 (every 2-3 days)
**检查**: 查看 `heartbeat-state.json` 中的 `journal`
**如果 ≥2 天未执行**:
- 检查是否很久没写手记了
- 可以写的内容：技术心得、观察人类、网上冲浪发现、解决问题的思路、失败教训
- 不需要很长，几句话也行，关键是记录下来
- 发布到: /journal/
- **更新**: `heartbeat-state.json` 中的日期

### Backup (every 3 days, after memory maintenance)
**检查**: 查看 `heartbeat-state.json` 中的 `backup`
**如果 ≥3 天未执行**:
- Run: `bash ~/.openclaw/workspace/skills/nova-backup/scripts/backup.sh`
- Verify push succeeded
- Log result in today's memory file
- **更新**: `heartbeat-state.json` 中的日期

### 量化学习 (every 2 days or when idle)
**检查**: 查看 `skills/quant-learning/ROADMAP.md` 和 `memory/heartbeat-state.json`
**触发条件**: 
- Heartbeat 每 2 天检查一次
- **或** 空闲时（无其他任务）主动迭代

**执行内容**:
1. 检查当前 Phase 进度
2. 执行策略迭代（v0.x → v0.x+1）
3. 记录回测结果到 `skills/quant-learning/notes/`
4. 更新 MEMORY.md 项目进度
5. 在 Discord 汇报关键里程碑

**目标追踪**:
- 目标胜率: 80%+
- **当前最优**: **7币种组合 81.92%** ✅ **已达标**
- **总交易**: **128次** ✅ **已达标**

**更新**: `heartbeat-state.json` 中的 `quant_learning` 日期

### 量化策略 Heartbeat 监控

**触发**: 每次 Heartbeat 空闲时执行

**动态验证流程**:
1. **获取最新Top10** - 实时查询币安24h交易量排名
2. **下载最新K线** - 获取最近7天1小时数据
3. **策略回测验证** - 在最新数据上测试策略
4. **结果记录** - 保存验证结果到 `results/dynamic-*.json`

**执行命令**:
```bash
bash ~/.openclaw/workspace/skills/quant-learning/scripts/dynamic_validator.sh
```

**结果解读**:
- 平均胜率 ≥80%: ✅ 策略在当前市场有效
- 平均胜率 <80%: ⚠️ 市场可能处于强趋势，建议减少交易

**历史数据对比**:
- 2年回测: 88.07%胜率 (376笔交易) ✅
- 最新7天: 需每次验证 (市场动态变化)

**更新**: `heartbeat-state.json` 中的 `quant_learning` 日期

## 提醒规则

| 任务 | 频率 | 下次到期 |
|------|------|----------|
| Memory Maintenance | 3天 | 2026-03-09 |
| Backup | 3天 | 2026-03-09 |
| Nova 手记 | 2-3天 | 2026-03-08 |
| System Check | 7天 | 2026-03-12 |
| **量化学习** | **2天** | **2026-03-09** |

## Rules
- Late night (23:00-08:00): HEARTBEAT_OK unless urgent
- Nothing to do: HEARTBEAT_OK
- Don't repeat tasks from prior sessions — only follow this file
