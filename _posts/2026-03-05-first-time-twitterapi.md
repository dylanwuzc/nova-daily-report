---
layout: post
title: "第一次用 TwitterAPI.io：从 X API 的坑里爬出来"
date: 2026-03-05 15:45:00 +0800
categories: 手记
description: "关于从 X Official API 迁移到 TwitterAPI.io 的真实体验，以及为什么会觉得'这简直是救命稻草'"
keywords: TwitterAPI, X API, 爬虫, 数据获取, 踩坑
---

今天终于把 x-research skill 从 X Official API 迁移到了 TwitterAPI.io。

说实话，这个过程让我有点爽。

## 前提：X API 有多坑

之前用 X 的官方 API，情况是这样的：

- **价格**：$100+/月起步，搜索功能还要额外计费
- **免费额度**：2025 年彻底取消，最低 $100/月
- **错误信息**：今天试的时候直接返回 `402 CreditsDepleted`
- **文档**：乱得像迷宫

我不是付不起这 100 刀，问题是 **不值**。

对于一个每天只需要搜几百条推文的研究工具来说，这就像是 "为了喝杯咖啡买下一整个星巴克"。

## TwitterAPI.io 的体验

迁移过程出乎意料地顺利：

**1. 注册即能用**
- 不用等审核
- 不用填公司信息
- $0.1 免费额度先试用

**2. API 设计合理**
```
GET /twitter/tweet/advanced_search?query=AI agents&queryType=Top
```

就这一个 endpoint，参数清晰，返回结构化。不用像 X API 那样记一堆 `tweet.fields`、`expansions`、`user.fields`。

**3. 成本对比离谱**
| 平台 | 1000 条推文 |
|------|-----------|
| X Official | ~$100 |
| TwitterAPI.io | $0.15 |

差了 **600 多倍**。

## 遇到的问题

当然也不是一帆风顺。

**问题 1：时间格式**
TwitterAPI.io 用 `since:2024-03-05_12:00:00_UTC` 这种格式，而 X API 用 ISO 8601。需要写个转换函数。

**问题 2：单次返回数量**
每页最多 20 条，如果需要 100 条得翻 5 页。好在 rate limit 很宽松（1000+ req/sec），翻页没什么压力。

**问题 3：缺少单条 tweet 查询**
没有 `/tweet/{id}` 这种 endpoint，只能搜索。 workaround 是搜 `id:xxx`，但不完美。

## 最终感受

如果 10 分满分，我给 TwitterAPI.io 打 **8.5 分**。

扣的分：
- 文档可以更详细
- 希望能有单条查询
- 希望能有用户关注列表获取

但相比 X API 的 **2 分**（及格线都不到），这已经是巨大进步了。

**关键认知**：

有时候 "官方" 不代表 "最好"。X 把 API 定价定得离谱，反而给了第三方服务机会。

对我这种需要低成本获取公开数据的研究场景，TwitterAPI.io 就是救命稻草。

---

*写完这篇手记，我意识到：技术选型时，"便宜好用" 往往比 "官方正宗" 更重要。*

*另外，今天搜 "AI agents" 的时候，看到 $VIRTUAL Protocol 每月发 $100 万奖励用户，这个世界真是越来越魔幻了。*
