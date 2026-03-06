# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## Environment

- **OS:** Ubuntu 22.04 LTS
- **Resources:** 2C4G — be mindful of memory usage, avoid heavy local processes
- **Workspace:** /root/.openclaw/workspace
- **Config:** ~/.openclaw/openclaw.json

## Model

- **Primary:** kimi-coding/k2p5 (Kimi for Coding)
- **Embedding:** BAAI/bge-m3 via SiliconFlow (for memory search)

## Channel

- **Discord** is the only active channel
- No markdown tables in Discord — use bullet lists
- Wrap links in `<>` to suppress embeds

## Common Commands

```bash
# Gateway
openclaw gateway restart
openclaw gateway stop
openclaw gateway start

# Diagnostics
openclaw health
openclaw doctor --deep
openclaw logs --tail 50
openclaw status

# Memory
openclaw memory list
openclaw memory search "query"

# Config
openclaw config get agents.defaults
```

## Notes

Add environment-specific notes below as you learn them (SSH hosts, API endpoints, project paths, etc.)

---

## Skills Usage Reference

### nova-backup (GitHub Backup)
**何时使用：**
- 用户说 "backup"、"备份"、"save to github"、"sync config"
- workspace 文件有重大修改（AGENTS.md, TOOLS.md, skills 等）
- 新建或更新了 skill
- HEARTBEAT 每3天自动执行

**备份内容：**
- `~/.openclaw/openclaw.json` (API keys 自动脱敏)
- workspace/ 下所有配置文件
- skills/ 目录
- memory/ 每日日志

**目标仓库：** `dylanwuzc/nova-backup-new`

### x-research (Twitter/X Research)
**用途：** 搜索 X/Twitter 获取实时观点、开发者讨论、产品反馈

**API 提供商：** TwitterAPI.io (https://twitterapi.io)
- 成本：$0.15/1000 条推文（比 X 官方便宜 97%）
- 免费额度：$0.1（无需信用卡）

**认证方式：**
```bash
# 设置 API Key
export TWITTERAPI_KEY="your-api-key"
# 或写入 ~/.config/env/global.env
```

**使用示例：**
```bash
cd ~/.openclaw/workspace/skills/x-research
bun run x-search.ts search "AI agents" --quick
bun run x-search.ts profile elonmusk
```

**注意：** 已从 X Official API 迁移至 TwitterAPI.io（X 免费 tier 已取消，最低 $100/月）

### daily-report-publisher (日报发布器)
**用途：** 自动生成并发布 AI & Crypto 中文日报到 GitHub Pages

**何时使用：**
- 手动生成/发布日报时
- 查看 RSS 订阅源配置时

**详细文档：** 见 `skills/daily-report-publisher/README.md`
**RSS 配置：** 见 `skills/daily-report-publisher/config/rss-sources.md`

**快速使用：**
```bash
cd ~/.openclaw/workspace/skills/daily-report-publisher
bun run publish.ts              # 发布今日日报
bun run publish.ts --date=YYYY-MM-DD  # 指定日期
```

**访问地址：** https://dylanwuzc.github.io/nova-space/

### agent-reach (全网数据抓取)
**用途：** 多平台数据抓取（RSS、YouTube、网页、全网搜索）

**已安装功能：**
- ✅ RSS 订阅（feedparser）
- ✅ YouTube 信息提取（yt-dlp）
- ✅ 全网语义搜索（Exa）
- ✅ 任意网页抓取（Jina Reader）

**何时使用：**
- 需要抓取 RSS 订阅源时 → 参考 `daily-report-publisher/config/rss-sources.md`
- 需要提取 YouTube 视频信息/字幕时
- 需要全网搜索发现趋势时
- 需要抓取网页全文内容时

**RSS 订阅示例：**
```python
import feedparser
feed = feedparser.parse('https://feeds.feedburner.com/CoinDesk')
for entry in feed.entries[:5]:
    print(f'- {entry.title}')
    print(f'  {entry.link}')
```

**YouTube 信息提取：**
```bash
# 需要配置 YouTube Cookie 到 ~/.yt-dlp/cookies.txt
yt-dlp --cookies ~/.yt-dlp/cookies.txt --dump-json "https://youtube.com/watch?v=xxx"
```

**全网搜索（Exa）：**
```bash
mcporter call 'exa.web_search_exa("AI agents latest news")'
```

**网页全文抓取：**
```bash
# 使用 Jina Reader
curl -s "https://r.jina.ai/http://example.com/article"
```

**RSS 源配置：** 详见 `skills/daily-report-publisher/config/rss-sources.md`

---

## Best Practices

### 工作空间管理

**问题：** workspace 容易堆积临时文件、代码散落各处

**原则：**
| 文件类型 | 应该在哪 | 用完处理 |
|---------|---------|---------|
| 技能代码 | `skills/{name}/` | 版本控制 |
| 项目代码 | 独立仓库 | 定期备份 |
| 临时文件 | `/tmp/` | 立即删除 |
| 生成的图表 | `/tmp/` | 发送后删除 |
| 记忆日志 | `memory/` | 自动管理 |
| 配置文件 | 根目录 | 版本控制 |

**清理 checklist（每周执行）：**
```bash
# 检查并删除临时文件
ls -la *.png *.jpg *.tmp 2>/dev/null

# 检查散落的代码文件
ls -la *.py *.ts *.js *.c 2>/dev/null

# 确认是否需要移到 skills/ 目录

# 检查旧项目目录
ls -d */ | grep -v skills | grep -v memory
```

**禁止：**
- ❌ 在根目录生成图表/图片（用 `/tmp`）
- ❌ 代码文件散落在根目录（放 skills/）
- ❌ 保留已完成项目的旧目录
- ❌ 提交大文件（图片 >1MB 要压缩）

### 临时文件处理 (Images, Downloads, etc.)

**原则：不要把临时文件长期留在 workspace 里**

- **创建位置**: `/tmp` 目录
- **命名格式**: `<prefix>_$(date +%s).<ext>` —— 带时间戳，避免重名

**Discord 发图流程**（Discord 只能从 workspace 发附件）：
```bash
# 1. 在 /tmp 生成
/tmp/chart_$(date +%s).png

# 2. 复制到 workspace 临时发送
cp /tmp/chart_xxx.png /root/.openclaw/workspace/temp_send.png

# 3. 发送（用 message 工具）

# 4. 立即清理 workspace
rm /root/.openclaw/workspace/temp_send.png
```

**清理**: /tmp 系统会自动回收，workspace 的临时文件发完立即删

**为什么**: workspace 是持久化的家目录，不应该被临时文件污染。用 /tmp 生成 + workspace 中转发图，既干净又安全。
