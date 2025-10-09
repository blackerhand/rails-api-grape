# Binance 深度信息服务
class Binance::DepthService < Binance::Base
  def initialize(symbol = 'BTCUSDT', limit = 100)
    @symbol = symbol
    @limit = limit
  end

  def execute
    get_depth(@symbol, @limit)
  end

  # 获取最佳买卖价格
  def get_best_prices
    result = get_depth(@symbol, 5)
    return result unless result[:success]

    data = result[:data]
    best_bid = data[:bids].first&.first&.to_f
    best_ask = data[:asks].first&.first&.to_f
    spread = best_ask - best_bid if best_bid && best_ask

    {
      success: true,
      data: {
        symbol: @symbol,
        best_bid: best_bid,
        best_ask: best_ask,
        spread: spread,
        spread_percentage: spread && best_bid ? (spread / best_bid * 100).round(4) : nil
      }
    }
  end

  def self.get_best_prices(symbol = 'BTCUSDT')
    new(symbol).get_best_prices
  end

  # 获取深度统计信息
  def get_depth_stats
    result = get_depth(@symbol, @limit)
    return result unless result[:success]

    data = result[:data]
    bids = data[:bids].map { |bid| [bid[0].to_f, bid[1].to_f] }
    asks = data[:asks].map { |ask| [ask[0].to_f, ask[1].to_f] }

    total_bid_volume = bids.sum { |_, volume| volume }
    total_ask_volume = asks.sum { |_, volume| volume }

    {
      success: true,
      data: {
        symbol: @symbol,
        total_bid_volume: total_bid_volume,
        total_ask_volume: total_ask_volume,
        volume_ratio: total_ask_volume > 0 ? (total_bid_volume / total_ask_volume).round(4) : nil,
        price_levels: { bids: bids.length, asks: asks.length }
      }
    }
  end

  def self.get_depth_stats(symbol = 'BTCUSDT', limit = 100)
    new(symbol, limit).get_depth_stats
  end
end
