class Api::V1::CandlesticksController < Api::V1::BaseApiController
  before_action :set_candlestick, only: [:info]

  def index
    limit_records = 10000
    merchandise_rate_id = params[:merchandise_rate_id]
    time_type = params[:time_type].to_i

    # @candlesticks là các cây nến trong thời gian hiện tại (lấy limit_records cây)
    # @candlesticks_future là các cây nến trong thời gian tương lai để làm backtest (lấy thêm limit_records cây trong tương lai)
    if params[:date].present?
      date = params[:date].to_datetime
      start_date, end_date, next_date = Candlestick.range_between_date date, time_type, limit_records
      @candlesticks = Candlestick.find_by_merchandise_rate(merchandise_rate_id.to_i, time_type, limit_records)
        .time_between(start_date, date)
        .sort_by{|c| c.date.to_i}
      @candlesticks_future = Candlestick.find_by_merchandise_rate(merchandise_rate_id.to_i, time_type, limit_records)
        .time_between(next_date, end_date)
        .sort_by{|c| c.date.to_i}
    else
      @candlesticks = Candlestick.find_by_merchandise_rate(merchandise_rate_id.to_i, time_type, limit_records)
        .sort_by{|c| c.date.to_i}
      @candlesticks_future = []
    end
  end

  def async_update_data
    time_type = params["time_type"]
    result = true

    if time_type.present?
      result = CreateCandlestickService.new(params["merchandise_rate_ids"], Candlestick.time_types.key(params["time_type"])).execute
    else
      Candlestick.time_types.keys.each do |interval|
        next if interval == 'm15'
        result = result && CreateCandlestickService.new(params["merchandise_rate_ids"], interval).execute
      end
    end

    Candlestick.update_candlestick_group

    render json: result
  end

  def merchandise_rates
    list_merchandise_rate_ids = Candlestick.list_merchandise_rate_id
    id_json = {}
    list_merchandise_rate_ids.each do |id|
      id_json[id.first] = MerchandiseRate.find(id.first).slug
    end

    render json: id_json
  end

  # https://github.com/bachpx195/the_big_trade/issues/42
  def monthly_return
    merchandise_rate_id = params[:merchandise_rate_id]
    using_markdown_text = params[:using_markdown_text]

    monthly_return_json = Candlestick.calculate_month_return merchandise_rate_id, using_markdown_text

    render json: monthly_return_json
  end

  def info
    info_json = {}
    candlestick_info_group = @candlestick.candlestick_info.group_candlestick_id

    if(params["info_type"] == "day")
      day_analytic = @candlestick.day_analytic

      info_json[:close] = @candlestick&.close
      info_json[:return_day] = day_analytic&.return_oc
      info_json[:return_oc] = day_analytic&.return_oc
      info_json[:return_hl] = day_analytic&.return_hl

      btc_candlestick = CandlestickInfo.where(merchandise_rate_id: 34, group_candlestick_id: candlestick_info_group).last.candlestick
      btc_day_analytic = btc_candlestick.day_analytic
      info_json[:btc_return_day] = btc_day_analytic.return_oc
      info_json[:btc_close] = btc_candlestick&.close

      altbtc_candlestick = CandlestickInfo.where(merchandise_rate_id: 41, group_candlestick_id: candlestick_info_group).last.candlestick
      altbtc_day_analytic = altbtc_candlestick.day_analytic
      info_json[:altbtc_return_day] = altbtc_day_analytic.return_oc
      info_json[:altbtc_close] = altbtc_candlestick&.close
    else
      hour_analytic = @candlestick.hour_analytic

      previous_day = Candlestick.where(merchandise_rate_id: hour_analytic.merchandise_rate_id, date: hour_analytic.date_with_binane).day.first
      previous_day_info_group = previous_day.candlestick_info.group_candlestick_id
      previous_24_hour = @candlestick.previous_24_hour
      previous_24_hour_info_group = previous_24_hour.candlestick_info.group_candlestick_id
      day_open = previous_day.open

      btc_candlestick = CandlestickInfo.where(merchandise_rate_id: 34, group_candlestick_id: candlestick_info_group).last.candlestick
      btc_previous_day = CandlestickInfo.where(merchandise_rate_id: 34, group_candlestick_id: previous_day_info_group).last.candlestick
      btc_previous_24_hour = CandlestickInfo.where(merchandise_rate_id: 34, group_candlestick_id: previous_24_hour_info_group).last.candlestick
      btc_day_open = btc_previous_day.open

      altbtc_candlestick = CandlestickInfo.where(merchandise_rate_id: 41, group_candlestick_id: candlestick_info_group).last.candlestick
      altbtc_previous_day = CandlestickInfo.where(merchandise_rate_id: 41, group_candlestick_id: previous_day_info_group).last.candlestick
      altbtc_previous_24_hour = CandlestickInfo.where(merchandise_rate_id: 41, group_candlestick_id: previous_24_hour_info_group).last.candlestick
      altbtc_day_open = altbtc_previous_day.open

      info_json[:return_day] = ((@candlestick.close - day_open)*100/day_open).round(2)
      info_json[:return_24h] = ((@candlestick.close - previous_24_hour.close)*100/previous_24_hour.close).round(2)
      info_json[:close] = @candlestick&.close
      info_json[:return_oc] = hour_analytic&.return_oc
      info_json[:return_hl] = hour_analytic&.return_hl

      info_json[:btc_return_day] = ((btc_candlestick.close - btc_day_open)*100/btc_day_open).round(2)
      info_json[:btc_return_24h] = ((btc_candlestick.close - btc_previous_24_hour.close)*100/btc_previous_24_hour.close).round(2)
      info_json[:btc_close] = btc_candlestick&.close

      info_json[:altbtc_return_day] = ((altbtc_candlestick.close - altbtc_day_open)*100/altbtc_day_open).round(2)
      info_json[:altbtc_return_24h] = ((altbtc_candlestick.close - altbtc_previous_24_hour.close)*100/altbtc_previous_24_hour.close).round(2)
      info_json[:altbtc_close] = altbtc_candlestick&.close
    end
    
    render json: info_json
  end

  private
  def set_candlestick
    @candlestick = Candlestick.find(params[:id])
  end
end
