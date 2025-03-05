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

  def merchandise_rates
    list_merchandise_rate_ids = DayAnalytic.list_merchandise_rate_id
    id_json = {}
    list_merchandise_rate_ids.each do |id|
      merchandise_rate_id = id.first
      merchandise_rate = MerchandiseRate.find(merchandise_rate_id)

      id_json[merchandise_rate_id] = [merchandise_rate.slug, DayAnalytic.where(merchandise_rate_id: merchandise_rate_id).count]
    end

    render json: id_json
  end

  def update_continuous
    DayAnalytic.update_continuous params["merchandise_rate_id"]

    render json: true
  end
end
