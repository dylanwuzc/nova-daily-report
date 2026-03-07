# 学习资源收集 - 量化交易数学与统计学

**日期**: 2026-03-07
**目的**: 提升策略胜率至80%，学习数学/统计学方法

---

## 📚 GitHub 优秀开源项目

### 网格策略专项
| 项目 | Stars | 特点 | 学习价值 |
|------|-------|------|----------|
| [OctoBot](https://github.com/Drakkar-Software/OctoBot) | 5,418 | 支持Grid/DCA/AI策略 | ⭐⭐⭐ 高，可直接研究 |
| [binance_grid_trader](https://github.com/51bitquant/binance_grid_trader) | 943 | 币安现货+合约网格 | ⭐⭐⭐ 高，专门网格 |
| [martin-binance](https://github.com/DogsTailFarmer/martin-binance) | 222 | 自适应马丁网格 | ⭐⭐⭐ 高，自适应逻辑 |
| [grid_trading_bot](https://github.com/jordantete/grid_trading_bot) | 126 | 简单网格实现 | ⭐⭐ 中，适合入门 |

### 回测框架
| 项目 | Stars | 特点 |
|------|-------|------|
| [rqalpha](https://github.com/ricequant/rqalpha) | 6,211 | 米筐回测框架，成熟稳定 |
| [pybroker](https://github.com/edtechre/pybroker) | 3,219 | 机器学习+回测 |
| [optopsy](https://github.com/goldspanlabs/optopsy) | 1,272 | 期权回测 |

---

## 📐 数学/统计学方法学习清单

### 提高胜率的核心数学概念

1. **概率论基础**
   - 条件概率: P(Win|Trend)
   - 贝叶斯定理: 根据新信息更新胜率估计
   - 期望值: E = P(win) × Profit - P(loss) × Loss

2. **统计学指标**
   - **夏普比率**: (收益 - 无风险利率) / 波动率
   - **胜率**: Wins / Total_Trades
   - **盈亏比**: Avg_Win / Avg_Loss
   - **最大回撤**: Peak_to_Trough
   - **Kelly公式**: f* = (bp - q) / b (最优仓位)

3. **时间序列分析**
   - 均值回归 (Mean Reversion)
   - 趋势跟随 (Trend Following)
   - 波动率聚类 (Volatility Clustering)
   - 自相关性 (Autocorrelation)

4. **风险管理数学**
   - 凯利公式: 最优仓位计算
   - 固定分数法: 固定风险比例
   - 马丁格尔: 亏损后加倍 (❌ 高风险)
   - 反马丁格尔: 盈利后加仓 (✅ 推荐)

---

## 🎯 关键学习方向 (针对80%胜率目标)

### 方向1: 入场条件优化
**问题**: 当前胜率65%，如何提高？
**数学方法**:
- 使用 **条件概率** 分析不同入场条件下的胜率
- 计算 P(Win | EMA_cross & ADX > x & Volatility < y)
- 找到最优阈值组合

### 方向2: 波动率自适应
**问题**: 固定网格不适应行情变化
**数学方法**:
- 使用 **ATR (Average True Range)** 动态调整网格间距
- 波动率 Regime Switching 模型
- GARCH 模型预测波动率

### 方向3: 趋势强度量化
**问题**: EMA过滤效果有限
**数学方法**:
- ADX (Average Directional Index)
- Hurst指数 (判断趋势/均值回归)
- 线性回归斜率

### 方向4: 凯利公式仓位管理
**问题**: 收益为负但胜率还可以
**数学方法**:
- 计算最优仓位: f* = (W × R - L) / R
  - W: 胜率
  - R: 盈亏比
  - L: 败率 (1-W)

---

## 📖 推荐学习资料

### 在线资源
1. **Quantopian Lectures** (Archive)
   - 统计套利、风险管理、回测方法
   
2. **Advances in Financial Machine Learning** (Marcos Lopez de Prado)
   - 金融机器学习经典
   - 样本内/样本外测试、交叉验证

3. **Python for Finance** (Yves Hilpisch)
   - Python量化金融
   - 衍生品定价、回测框架

### 数学工具
```python
# 需要学习的库
import scipy.stats as stats    # 统计检验
import numpy as np             # 数值计算
import pandas as pd            # 数据处理
import statsmodels.api as sm   # 时间序列分析
from arch import arch_model    # GARCH波动率模型
```

---

## 🔬 下一步学习计划

### 立即执行 (下次空闲时)
1. **阅读 OctoBot 网格策略源码**
   - 学习其 Grid 模式实现
   - 分析其动态调整逻辑

2. **学习凯利公式应用**
   - 计算当前策略的最优仓位
   - 验证是否能改善收益

3. **波动率Regime分析**
   - 划分高/低波动率时期
   - 测试不同参数在各Regime的表现

### 短期目标 (本周)
- [ ] 实现波动率自适应网格
- [ ] 加入凯利公式仓位管理
- [ ] 测试多时间框架确认 (1h + 4h)

### 中期目标 (本月)
- [ ] 实现Bayesian胜率预测
- [ ] 机器学习特征工程
- [ ] 多币种策略验证

---

## 💡 关键洞察

从开源项目学习到的:
1. **自适应网格**: 好的网格策略会根据波动率动态调整间距
2. **多时间框架**: 大时间框架定方向，小时间框架执行
3. **严格风控**: 每笔交易固定风险比例，不马丁
4. **统计验证**: 需要足够样本量 (至少100+笔交易)

**我的策略差距**:
- ❌ 没有自适应调整
- ❌ 仓位固定，没有根据胜率调整
- ❌ 单一时间框架
- ❌ 没有波动率Regime识别

---

**学习承诺**: 每轮迭代都加入新的数学/统计方法，持续提升策略质量！
