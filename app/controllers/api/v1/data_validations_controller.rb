class Api::V1::DataValidationsController < Api::V1::BaseApiController

  def day_analytics
    result = DataValidations::DayAnalyticValidationService.new(params[:merchandise_rate_id]).execute

    render json: result
  end

  def hour_analytics
    result = DataValidations::HourAnalyticValidationService.new(params[:merchandise_rate_id]).execute

    render json: result
  end
end
