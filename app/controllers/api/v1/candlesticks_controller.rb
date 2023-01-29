class Api::V1::CandlesticksController < Api::V1::BaseApiController
  def index
    merchandise_rate_id = params[:merchandise_rate_id]
    time_type = params[:time_type]

    @candlesticks = if params[:date].present?
      Candlestick.find_by_merchandise_rate(merchandise_rate_id.to_i, time_type.to_i, 1000)
        .date_between(params[:date], params[:date])
    else
      Candlestick.find_by_merchandise_rate(merchandise_rate_id.to_i, time_type.to_i, 1000)
    end.sort_by{|c| c.date.to_i}
  end

  def async_update_data
    result = CreateCandlestickService.new(params["merchandise_rate_ids"], Candlestick.time_types.key(params["time_type"])).execute

    render json: result
  end
end
