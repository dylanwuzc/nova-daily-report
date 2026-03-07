# Daily Report Publisher

自动生成并发布 AI & Crypto 中文日报到 GitHub Pages。

## 功能

- 每日自动生成格式化日报（中文）
- 按主题分类：AI智能体、量化交易、模型发展、加密交易
- 自动发布到 GitHub Pages
- 支持历史归档和主题浏览
- **数据源**: RSS订阅 + Web搜索（~~Twitter 已停用~~）

## 数据源

| 类型 | 工具 | 内容 | 状态 |
|------|------|------|------|
| **RSS** | feedparser | 官方新闻、深度报道 | ✅ 主要来源 |
| **全网搜索** | Agent Reach - Exa | 语义搜索、趋势发现 | ✅ 补充 |
| **网页抓取** | Jina Reader | 文章全文、细节补充 | ✅ 补充 |
| ~~Twitter/X~~ | ~~x-research~~ | ~~实时讨论~~ | ❌ 已停用（未充值） |

### RSS 订阅源

详见 `config/rss-sources.md`

**核心源**:
- CoinDesk - 加密新闻
- OpenAI Blog - AI 研究动态
- Hacker News - 技术社区热点
- Decrypt - Web3/DeFi 新闻
- Import AI - AI 周报

## 使用方法

### 方式一：手动执行研究任务（推荐）

```bash
# 1. 执行 RSS 采集
bash ~/.openclaw/workspace/skills/daily-report-publisher/scripts/run-daily-research.sh

# 2. 查看采集结果
cat /tmp/research_$(date +%Y%m%d)/rss_content.txt

# 3. 手动整理内容，生成日报 Markdown 文件
# 保存到: ~/.openclaw/workspace/nova-daily-report/_posts/YYYY-MM-DD-daily.md

# 4. 提交到 GitHub
cd ~/.openclaw/workspace/nova-daily-report
git add .
git commit -m "Add daily report: YYYY-MM-DD"
git push origin main
```

### 方式二：直接采集 RSS

```python
import feedparser

# CoinDesk
feed = feedparser.parse("https://feeds.feedburner.com/CoinDesk")
for entry in feed.entries[:5]:
    print(f"- {entry.title}")
    print(f"  {entry.link}")
```

### 方式三：使用 publish.ts（需要配置）

```bash
cd ~/.openclaw/workspace/skills/daily-report-publisher
bun run publish.ts              # 发布今日日报
bun run publish.ts --date=YYYY-MM-DD  # 指定日期
```

## 日报内容要求

### 数量要求
- 每个栏目至少 **3-5 条** 有用的新闻
- 除非当天确实没有相关新闻
- 宁缺毋滥：质量 > 数量

### 内容筛选标准
- ✅ 有实际价值（有洞察、有可操作性）
- ✅ 有信息增量（不是重复已知信息）
- ✅ 有来源可追溯
- ❌ 避免低质量聚合内容
- ❌ 避免纯营销软文

### 日报结构

```markdown
---
layout: post
title: "AI & Crypto 日报 - YYYY年MM月DD日"
date: YYYY-MM-DD 03:00:00 +0800
categories: [分类1, 分类2, 分类3]
---

## 今日速览
（3-5 条核心要点）

## 🤖 AI 智能体
（3-5 条新闻，每条包含：发生了什么、为什么重要、对你有什么用）

## 💰 加密交易
（3-5 条新闻）

## 📊 市场情绪
（简要数据表）

## 🔮 明日关注
（1-2 条值得关注的事件）

## 📰 关于本日报
**数据来源**: RSS 订阅
```

## 配置

### 基础配置

编辑 `~/.openclaw/workspace/.daily-report-config.json`：

```json
{
  "repo": "dylanwuzc/nova-space",
  "branch": "main",
  "local_path": "/root/.openclaw/workspace/nova-daily-report",
  "site_url": "https://dylanwuzc.github.io/nova-space"
}
```

## 目录结构

```
daily-report-publisher/
├── config/
│   └── rss-sources.md          # RSS 订阅源配置
├── scripts/
│   └── run-daily-research.sh   # 每日研究任务脚本（RSS采集）
├── templates/                   # Jekyll 模板文件
├── README.md                    # 本文件
└── publish.ts                   # 发布脚本
```

## 自动化（Cron）

已配置 OpenClaw Cron 任务：
- **执行时间**：每天凌晨 3:00 (Asia/Shanghai)
- **任务类型**：isolated session
- **输出**：自动发布到 Discord #nova-channel

查看任务状态：
```bash
openclaw cron list
```

## 访问日报

- **站点首页**：https://dylanwuzc.github.io/nova-space/
- **日报示例**：https://dylanwuzc.github.io/nova-space/2026/03/07/daily/

## 故障排查

**问题：RSS 抓取为空**
- 原因：RSS 源失效或格式变更
- 解决：检查 `config/rss-sources.md` 中的 URL 是否有效
- 验证命令：`curl -I https://feeds.feedburner.com/CoinDesk`

**问题：GitHub Pages 未更新**
- 原因：构建失败或缓存
- 解决：检查 GitHub Actions 日志，或强制刷新浏览器 (Ctrl+F5)

**问题：脚本权限错误**
- 解决：`chmod +x scripts/run-daily-research.sh`

## 注意事项

1. **内容数量**: 每个栏目至少 3-5 条有用新闻
2. **图片方案**: 使用外部 URL（Unsplash、项目官网等），不存本地
3. **Git 提交**: 发布前确保已配置 Git 用户名和邮箱
4. **Twitter 已停用**: 不要尝试调用 x-research，API 未充值

---
*Daily Report Publisher v1.1 | Nova Research*
