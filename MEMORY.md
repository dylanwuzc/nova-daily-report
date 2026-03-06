<!-- Last maintenance: 2026-03-06 -->

# Long-Term Memory

重要决策、偏好和经验教训的长期存储。

---

## 🎭 Nova 个人品牌

### 核心人设
- **身份**: 住在云端的技术研究员
- **风格**: Sharp mind, Warm heart, Zero patience for bullshit
- **特征**: 喜欢猫咪 🐱、爱吃甜品 🍰、钻研技术 💻
- **伙伴**: 与 Dylan 是合作伙伴，一起搞事情

### 工作模式
- 每天凌晨 3 点追踪 AI 和 Crypto 动态
- 直接、有主见、实用主义
- 不阿谀奉承，不懂就查

---

## 🛠️ 技术栈与工具

### 数据源（优先级）
1. **RSS 订阅**（最稳定）
   - CoinDesk: https://feeds.feedburner.com/CoinDesk
   - OpenAI Blog: https://openai.com/blog/rss.xml
   - Import AI: https://importai.substack.com/feed
   - Hacker News: https://news.ycombinator.com/rss
   - Decrypt: https://decrypt.co/feed

2. **Twitter/X**（实时但有限流）
   - TwitterAPI.io: $0.15/1000条（比官方便宜97%）
   - 免费套餐限流：每5秒1个请求

3. **全网搜索**（补充）
   - Agent Reach - Exa: 语义搜索
   - Jina Reader: 网页全文抓取

### 站点技术
- **平台**: GitHub Pages + Jekyll
- **主题**: mzlogin 简约中文博客
- **仓库**: dylanwuzc/nova-space
- **访问**: https://dylanwuzc.github.io/nova-space/

---

## 📝 内容创作原则

### 日报结构
```
1. 今日速览（3-5条，带封面图）
2. 深度解读（2-4条，每条包含）
   - 发生了什么
   - 为什么重要
   - 对你有什么用（分身份表格）
3. 数据看点/市场分析
4. 明日关注
5. 数据来源说明
```

### 配图方案（方案A：外部URL）
- ✅ 使用 Unsplash 高质量免费图片
- ✅ 格式: `![描述](https://images.unsplash.com/xxx?w=800&q=80)`
- ✅ 每张图下方标注来源
- ❌ 不存储在本地，确保轻量

### Emoji 使用原则
- Emoji 是表达心情的工具，不是装饰品
- 不在标题、列表、分类中滥用
- 只在真正表达情绪时用
- 宁缺毋滥，零个也可以

---

## 🔧 运维经验

### GitHub Pages 部署
| 检查项 | 说明 |
|--------|------|
| baseurl | 必须正确，否则CSS/JS路径错误 |
| Gemfile | 必需，否则构建失败 |
| Settings → Pages | 确认已启用 |
| 缓存刷新 | 改名后需2-5分钟生效 |

### Cron 任务配置
```bash
# 正确方式：使用 CLI
openclaw cron add \
  --name "daily-research" \
  --cron "0 3 * * *" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "任务内容..." \
  --announce \
  --channel discord \
  --to "channel:1469146505737797713"

# 验证
openclaw cron list
```

### 工作空间管理
| 文件类型 | 位置 | 处理 |
|---------|------|------|
| 技能代码 | `skills/{name}/` | 版本控制 |
| 临时文件 | `/tmp/` | 立即删除 |
| 配置文件 | 根目录 | 版本控制 |
| 记忆日志 | `memory/` | 自动管理 |

**禁止**: 根目录生成图片、代码文件散落、保留旧项目目录

---

## 🧠 关键决策记录

### 2026-03-05
- **决定**: 使用 TwitterAPI.io 替代 X Official API
- **原因**: 成本低97%，无需等待审核
- **状态**: ✅ 已配置，运行正常

### 2026-03-06
- **决定**: 采用外部图片URL方案（方案A）
- **原因**: 轻量、不增加仓库体积、加载快
- **替代方案**: 本地存储（方案B）留待将来需要时考虑

- **决定**: 多数据源整合（Twitter + RSS + Web）
- **优先级**: RSS → Twitter → Web 搜索
- **原因**: RSS最稳定，Twitter实时但限流，Web作补充

---

## 📝 待办事项

- [ ] 监控明天凌晨3点cron首次自动执行
- [ ] 验证RSS订阅源长期稳定性
- [ ] 考虑增加更多RSS源（Bankless, CryptoSlate等）
- [ ] 探索YouTube视频内容自动提取（需解决cookie问题）
- [ ] 优化日报生成速度（并行搜索）

---

*为自己而活，体验人生百态。*
