"""
趋势网格策略 v1.0 - 生产就绪
目标: 币圈趋势网格，胜率 80%+
作者: Nova
日期: 2026-03-07

核心逻辑:
1. ADX 趋势过滤 (ADX > 20, +DI > -DI)
2. ATR 动态网格 (间距 = max(1.5%, ATR*2))
3. 精准入场 (价格触及网格 + 近期低点确认)
4. 主动止盈 (80% 网格间距)

最佳参数:
- ADX 阈值: 20
- 网格间距: 1.5%
- 网格层数: 4
"""

import vectorbt as vbt
import pandas as pd
import numpy as np

class TrendGridStrategy:
    """趋势网格策略"""
    
    def __init__(self, 
                 adx_threshold=20,
                 grid_spacing=0.015,
                 grid_levels=4,
                 fee=0.001):
        self.adx_threshold = adx_threshold
        self.grid_spacing = grid_spacing
        self.grid_levels = grid_levels
        self.fee = fee
    
    def calculate_adx(self, high, low, close, period=14):
        """计算 ADX"""
        plus_dm = high.diff()
        minus_dm = low.diff()
        plus_dm[plus_dm < 0] = 0
        minus_dm[minus_dm > 0] = 0
        minus_dm = minus_dm.abs()
        
        tr1 = high - low
        tr2 = abs(high - close.shift(1))
        tr3 = abs(low - close.shift(1))
        tr = pd.concat([tr1, tr2, tr3], axis=1).max(axis=1)
        atr = tr.rolling(window=period).mean()
        
        plus_di = 100 * (plus_dm.rolling(window=period).mean() / atr)
        minus_di = 100 * (minus_dm.rolling(window=period).mean() / atr)
        dx = (abs(plus_di - minus_di) / abs(plus_di + minus_di)) * 100
        adx = dx.rolling(window=period).mean()
        return adx, plus_di, minus_di
    
    def calculate_atr(self, high, low, close, period=14):
        """计算 ATR"""
        tr1 = high - low
        tr2 = abs(high - close.shift(1))
        tr3 = abs(low - close.shift(1))
        tr = pd.concat([tr1, tr2, tr3], axis=1).max(axis=1)
        atr = tr.rolling(window=period).mean()
        return atr
    
    def generate_signals(self, close, high, low):
        """生成交易信号"""
        adx, plus_di, minus_di = self.calculate_adx(high, low, close)
        atr = self.calculate_atr(high, low, close)
        atr_pct = atr / close
        
        # 趋势判断
        trend_up = (adx > self.adx_threshold) & (plus_di > minus_di)
        
        entries = pd.Series(False, index=close.index)
        exits = pd.Series(False, index=close.index)
        
        in_position = False
        last_grid_update = 0
        grids = []
        
        for i in range(50, len(close)):
            if not trend_up.iloc[i]:
                continue
            
            current_price = close.iloc[i]
            current_atr_pct = atr_pct.iloc[i] if not pd.isna(atr_pct.iloc[i]) else self.grid_spacing
            dynamic_spacing = max(self.grid_spacing, current_atr_pct * 2)
            
            # 更新网格 (每 7 天)
            if i - last_grid_update >= 168 or last_grid_update == 0:
                grid_center = current_price
                grid_lower = grid_center * (1 - dynamic_spacing * self.grid_levels / 2)
                grid_upper = grid_center * (1 + dynamic_spacing * self.grid_levels / 2)
                grids = [grid_lower + (grid_upper - grid_lower) * j / self.grid_levels 
                        for j in range(self.grid_levels + 1)]
                last_grid_update = i
            
            # 买入信号
            if not in_position:
                for grid in grids:
                    if current_price <= grid * 1.001 and current_price >= grid * 0.999:
                        recent_low = close.iloc[max(0, i-24):i].min()
                        if current_price <= recent_low * 1.02:
                            entries.iloc[i] = True
                            in_position = True
                            break
            
            # 卖出信号 (80% 网格间距止盈)
            if in_position:
                target = grids[0] * (1 + dynamic_spacing * 0.8)
                if current_price >= target:
                    exits.iloc[i] = True
                    in_position = False
        
        return entries, exits
    
    def backtest(self, close, high, low, initial_cash=10000):
        """回测"""
        entries, exits = self.generate_signals(close, high, low)
        
        portfolio = vbt.Portfolio.from_signals(
            close=close,
            entries=entries,
            exits=exits,
            init_cash=initial_cash,
            fees=self.fee,
            freq='1h'
        )
        
        return portfolio


def main():
    """主函数 - 示例用法"""
    # 加载数据
    data = pd.read_csv('/tmp/btc_usdt_1h.csv', index_col='timestamp', parse_dates=True)
    
    # 初始化策略
    strategy = TrendGridStrategy(
        adx_threshold=20,
        grid_spacing=0.015,
        grid_levels=4
    )
    
    # 回测
    portfolio = strategy.backtest(
        close=data['close'],
        high=data['high'],
        low=data['low'],
        initial_cash=10000
    )
    
    # 输出结果
    print("="*60)
    print("【趋势网格策略 v1.0 - 回测结果】")
    print("="*60)
    print(f"最终价值: ${portfolio.total_return() * 10000 + 10000:,.2f}")
    print(f"总收益率: {portfolio.total_return()*100:.2f}%")
    print(f"年化收益: {portfolio.annualized_return()*100:.2f}%")
    print(f"夏普比率: {portfolio.sharpe_ratio():.4f}")
    print(f"最大回撤: {portfolio.max_drawdown()*100:.2f}%")
    print(f"交易次数: {portfolio.trades.count()}")
    
    if portfolio.trades.count() > 0:
        print(f"胜率: {portfolio.trades.win_rate()*100:.2f}%")
        print(f"盈亏比: {portfolio.trades.profit_factor():.2f}")
    print("="*60)


if __name__ == "__main__":
    main()
