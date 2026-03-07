# Daily Report Publisher

自动生成并发布 AI & Crypto 中文日报到 GitHub Pages。

## 功能

- 每日自动生成格式化日报（中文）
- 按主题分类：AI智能体、量化交易、模型发展、加密交易
- 自动发布到 GitHub Pages
- 支持历史归档和主题浏览
- **数据源**: RSS订阅 + Web搜索（~~Twitter 已停用~~）

## 配置

### 1. 基础配置

编辑 `~/.openclaw/workspace/.daily-report-config.json`：

```json
{
  "repo": "dylanwuzc/nova-space",
  "branch": "main",
  "local_path": "/root/.openclaw/workspace/nova-daily-report",
  "site_url": "https://dylanwuzc.github.io/nova-space"
}
```

### 2. RSS 订阅源配置

详见 `config/rss-sources.md`

## 使用

### 初始化（首次运行）

```bash
cd ~/.openclaw/workspace/skills/daily-report-publisher
bun run init.ts
```

### 发布日报

```bash
# 发布今日日报
bun run publish.ts

# 指定日期发布
bun run publish.ts --date=2026-03-05
```

### 手动执行研究任务

```bash
# 执行搜索和整理（不自动发布）
bash scripts/run-daily-research.sh
```

## 目录结构

```
daily-report-publisher/
├── config/
│   └── rss-sources.md          # RSS 订阅源配置
├── scripts/
│   └── run-daily-research.sh   # 每日研究任务脚本
├── templates/                   # Jekyll 模板文件
│   ├── _config.yml
│   ├── _layouts/
│   └── ...
├── README.md                    # 本文件
└── publish.ts                   # 发布脚本
```

## 数据源

| 类型 | 工具 | 内容 | 状态 |
|------|------|------|------|
| **RSS** | feedparser | 官方新闻、深度报道 | ✅ 主要来源 |
| **全网搜索** | Agent Reach - Exa | 语义搜索、趋势发现 | ✅ 补充 |
| **网页抓取** | Jina Reader | 文章全文、细节补充 | ✅ 补充 |
| ~~Twitter/X~~ | ~~x-research~~ | ~~实时讨论~~ | ❌ 已停用 |

## 自动化

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
- **日报示例**：https://dylanwuzc.github.io/nova-space/2026/03/06/daily/

## 注意事项

1. **内容数量要求**（重要）
   - 每个栏目至少 **3-5 条** 有用的新闻
   - 除非当天确实没有相关新闻
   - 宁缺毋滥：质量 > 数量

2. **内容筛选标准**
   - 有实际价值（有洞察、有可操作性）
   - 有信息增量（不是重复已知信息）
   - 有来源可追溯

3. **RSS 源稳定性**：定期检查 RSS 源是否有效
3. **图片方案**：使用外部 URL（Unsplash、Twitter媒体等），不存本地
4. **Git 提交**：发布前确保已配置 Git 用户名和邮箱

## 故障排查

**问题：TwitterAPI 返回 429 Too Many Requests**
- 原因：超过免费套餐 QPS 限制
- 解决：降低搜索频率，或升级套餐

**问题：RSS 抓取为空**
- 原因：RSS 源失效或格式变更
- 解决：检查 `config/rss-sources.md` 中的 URL 是否有效

**问题：GitHub Pages 未更新**
- 原因：构建失败或缓存
- 解决：检查 GitHub Actions 日志，或强制刷新浏览器

---
*Daily Report Publisher v1.0 | Nova Research*
