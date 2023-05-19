class Api::V1::CandlesticksController < Api::V1::BaseApiController
  def index
    merchandise_rate_id = params[:merchandise_rate_id]
    time_type = params[:time_type]

    # @candlesticks là các cây nến trong thời gian hiện tại (lấy 100 cây)
    # @candlesticks_future là các cây nến trong thời gian tương lai để làm backtest (lấy thêm 100 cây trong tương lai)
    if params[:date].present?
      date = params[:date].to_datetime
      start_date, end_date, next_date = Candlestick.range_between_date date, params[:time_type].to_i
      @candlesticks = Candlestick.find_by_merchandise_rate(merchandise_rate_id.to_i, time_type.to_i, 1000)
        .date_between(start_date, params[:date])
        .sort_by{|c| c.date.to_i}
      @candlesticks_future = Candlestick.find_by_merchandise_rate(merchandise_rate_id.to_i, time_type.to_i, 1000)
        .date_between(next_date, end_date)
        .sort_by{|c| c.date.to_i}
    else
      @candlesticks = Candlestick.find_by_merchandise_rate(merchandise_rate_id.to_i, time_type.to_i, 1000)
        .sort_by{|c| c.date.to_i}
      @candlesticks_future = []
    end
  end

  def async_update_data
    result = CreateCandlestickService.new(params["merchandise_rate_ids"], Candlestick.time_types.key(params["time_type"])).execute

    render json: result
  end
end
