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

## 提醒规则

| 任务 | 频率 | 下次到期 |
|------|------|----------|
| Memory Maintenance | 3天 | 2026-03-09 |
| Backup | 3天 | 2026-03-09 |
| Nova 手记 | 2-3天 | 2026-03-08 |
| System Check | 7天 | 2026-03-12 |

## Rules
- Late night (23:00-08:00): HEARTBEAT_OK unless urgent
- Nothing to do: HEARTBEAT_OK
- Don't repeat tasks from prior sessions — only follow this file
