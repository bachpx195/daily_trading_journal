class Api::V1::CandlesticksController < Api::V1::BaseApiController
  def index
    merchandise_rate_id = params[:merchandise_rate_id]
    time_type = params[:time_type]

    @candlesticks = Candlestick.find_by_merchandise_rate merchandise_rate_id.to_i, time_type.to_i
  end
end
