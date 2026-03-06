# RSS 订阅源配置

## 已验证有效的 RSS 源

### 🤖 AI / 技术方向

| 来源 | RSS 地址 | 更新频率 | 说明 |
|------|---------|----------|------|
| **OpenAI Blog** | https://openai.com/blog/rss.xml | 低频 | GPT、Claude 等模型官方更新 |
| **Import AI** | https://importai.substack.com/feed | 周刊 | Jack Clark 的 AI 政策/研究周报 |
| **Hacker News** | https://news.ycombinator.com/rss | 实时 | 技术社区热点，开发者讨论 |

### 💰 加密 / Web3 方向

| 来源 | RSS 地址 | 更新频率 | 说明 |
|------|---------|----------|------|
| **CoinDesk** | https://feeds.feedburner.com/CoinDesk | 日更 | 加密新闻主流平台 |
| **The Block** | https://www.theblock.co/rss.xml | 日更 | 深度报道，机构视角 |
| **Decrypt** | https://decrypt.co/feed | 日更 | Web3/DeFi 新闻 |

### 📝 综合技术 / 开发者

| 来源 | RSS 地址 | 说明 |
|------|---------|------|
| **TechCrunch** | https://techcrunch.com/feed/ | 科技创业新闻 |
| **MIT Technology Review** | https://www.technologyreview.com/feed/ | MIT 科技评论 |

## 使用方式

```python
import feedparser

# 示例：读取 CoinDesk
feed = feedparser.parse("https://feeds.feedburner.com/CoinDesk")
for entry in feed.entries[:5]:
    print(f"- {entry.title}")
    print(f"  {entry.link}")
```

## 添加新 RSS 源流程

1. **验证有效性**
   ```python
   import feedparser
   feed = feedparser.parse("https://example.com/rss")
   print(f"文章数: {len(feed.entries)}")
   ```

2. **更新此配置文件**
   - 添加到上表
   - 注明类型和说明

3. **更新 cron 任务提示**
   - 在 `openclaw cron edit` 中加入新 RSS 源

## 注意事项

- 优先选择 **RSS 全文输出** 的源（非摘要）
- 更新频率：**实时/日更** 优于 **周刊**
- 内容质量：**官方博客** > **媒体转载** > **聚合站点**
- 稳定性：优先选择 **FeedBurner**、**官方域名** 托管的源

---
*此配置文件属于 daily-report-publisher skill*
