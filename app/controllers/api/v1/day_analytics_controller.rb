class Api::V1::DayAnalyticsController < Api::V1::BaseApiController
  def create
    CreateDayAnalyticService.new(params["merchandise_rate_ids"], params["start_date"]).execute

    render json: true
  end
  
  def update_hour_analytic
    UpdateDayAnalyticService.new(params["merchandise_rate_ids"], params["start_date"]).execute

    render json: true
  end

  def last_updated_date
    day_analytics = DayAnalytic.not_update_hour_analytic(params["merchandise_rate_id"])

    render json: {date: day_analytics&.pluck(:date)}
  end
end
