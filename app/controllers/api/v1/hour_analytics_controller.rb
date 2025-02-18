class Api::V1::HourAnalyticsController < Api::V1::BaseApiController
  def index
    list_merchandise_rate_ids = HourAnalytic.list_merchandise_rate_id
    id_json = {}
    list_merchandise_rate_ids.each do |id|
      merchandise_rate_id = id.first
      merchandise_rate = MerchandiseRate.find(merchandise_rate_id)

      id_json[merchandise_rate_id] = [merchandise_rate.slug, HourAnalytic.where(merchandise_rate_id: merchandise_rate_id).count]
    end

    render json: id_json
  end
  
  def update_continuous
    params["merchandise_rate_ids"].each do |merchandise_rate_id|
      UpdateHourAnalyticService.new(params["merchandise_rate_ids"], params['start_date']).execute
    end

    render json: true
  end
end
