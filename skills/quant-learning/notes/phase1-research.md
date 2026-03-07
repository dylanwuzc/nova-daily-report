# 量化学习笔记 - Phase 1: 资料收集

**日期**: 2026-03-07
**阶段**: Phase 1/4 - 资料收集

---

## GitHub 调研结果

### 币圈量化框架 (Top 5)

| 项目 | Stars | 描述 | 适用性评估 |
|------|-------|------|-----------|
| **freqtrade/freqtrade** | 47k+ | 开源币圈交易机器人 | ⭐⭐⭐ 首选 |
| **ccxt/ccxt** | 41k+ | 加密货币交易所 API 封装 | ⭐⭐⭐ 必备基础 |
| **hummingbot/hummingbot** | 17k+ | 高频/做市策略 | ⭐⭐⭐ 专业级 |
| **Drakkar-Software/OctoBot** | 5k+ | 支持 Grid、DCA、AI 策略 | ⭐⭐⭐ **网格首选** |
| **blankly-finance/blankly** | 2k+ | 快速部署策略框架 | ⭐⭐ 备选 |

### 网格策略专项 (Top 3)

| 项目 | Stars | 描述 | 评估 |
|------|-------|------|------|
| **Open-Trader/opentrader** | 2.2k | DCA & GRID 策略 | 较新，活跃 |
| **jordantete/grid_trading_bot** | 126 | 专门网格交易机器人 | 简洁专注 |
| **princeniu/AS-Grid** | 36 | 多交易所多币种网格 | 功能完整 |

### 回测框架 (Top 3)

| 项目 | Stars | 描述 | 评估 |
|------|-------|------|------|
| **mementum/backtrader** | 20k+ | Python 回测库，文档丰富 | ⭐⭐⭐ 经典 |
| **kernc/backtesting.py** | 8k+ | 高性能回测，向量化 | ⭐⭐⭐ 推荐 |
| **pmorissette/ffn** | - | 金融函数库 | ⭐⭐ 辅助 |

---

## 技术选型建议

### 推荐组合

**方案 A: 全能型**
- 框架: **Freqtrade** (47k stars, 活跃)
- 回测: 内置回测 + Jupyter
- 优势: 生态完善，策略丰富，文档全
- 劣势: 学习曲线较陡

**方案 B: 网格专用**
- 框架: **OctoBot** (5k stars, 支持 Grid/DCA/AI)
- 回测: 内置回测
- 优势: 专门支持网格，配置简单
- 劣势: 自定义能力有限

**方案 C: 自研轻量**
- 回测: **backtesting.py** (8k stars, 向量化高性能)
- 数据源: CCXT + Binance
- 优势: 完全可控，性能高
- 劣势: 需要较多开发工作

### 我的选择

**推荐方案 C (backtesting.py + CCXT)**

原因:
1. 学习价值最大，理解底层逻辑
2. 向量化回测性能高，适合参数优化
3. 80% 胜率目标需要精细控制策略逻辑
4. 代码简洁，易于调试和迭代

---

## 下一步行动

1. **安装环境**
   ```bash
   pip install backtesting ccxt pandas numpy
   ```

2. **获取数据**
   - 使用 CCXT 下载 Binance BTC/USDT 永续合约历史数据
   - 时间范围: 2023-01-01 至今
   - 时间周期: 1h, 4h

3. **学习 backtesting.py**
   - 阅读官方文档
   - 跑通示例策略
   - 理解 Strategy 类结构

---

## 参考资料

- Freqtrade: https://github.com/freqtrade/freqtrade
- OctoBot: https://github.com/Drakkar-Software/OctoBot
- backtesting.py: https://kernc.github.io/backtesting.py/
- CCXT: https://github.com/ccxt/ccxt

---

*下次更新: 2026-03-09 (Phase 1 完成评估)*
