require 'binance'

# Binance API 基础服务类
class Binance::Base < BaseService
  def client
    @client ||= Binance::Spot.new(
      key: Settings.BINANCE_API_KEY,
      secret: Settings.BINANCE_SECRET_KEY,
      base_url: Settings.BINANCE_BASE_URL
    )
  end

  # 获取市场深度信息
  def self.get_depth(symbol, limit = 100)
    new.get_depth(symbol, limit)
  end

  def get_depth(symbol, limit = 100)
    response = client.depth(symbol: symbol, limit: limit)
    {
      success: true,
      data: {
        symbol: response['symbol'],
        bids: response['bids'],
        asks: response['asks'],
        last_update_id: response['lastUpdateId']
      }
    }
  rescue StandardError => e
    { success: false, error: e.message, data: nil }
  end

  # 获取24小时价格变动统计
  def self.get_24hr_ticker(symbol = nil)
    new.get_24hr_ticker(symbol)
  end

  def get_24hr_ticker(symbol = nil)
    response = symbol ? client.ticker_24hr(symbol: symbol) : client.ticker_24hr
    { success: true, data: response }
  rescue StandardError => e
    { success: false, error: e.message, data: nil }
  end

  # 获取服务器时间
  def self.get_server_time
    new.get_server_time
  end

  def get_server_time
    response = client.time
    {
      success: true,
      data: {
        server_time: response['serverTime'],
        timestamp: Time.at(response['serverTime'] / 1000)
      }
    }
  rescue StandardError => e
    { success: false, error: e.message, data: nil }
  end

  def execute
    # 基础服务不需要实现 execute 方法
  end
end
