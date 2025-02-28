class Api::V1::EventDatesController < Api::V1::BaseApiController
  before_action :set_event, only: [:index]
  before_action :set_merchandise_rate, only: [:index, :list_event]

  def index
    start_date, end_date = @merchandise_rate.start_end_date Candlestick.time_types.key(params[:interval].to_i)
    result_array = DateMaster.joins(:event_masters)
                      .where(event_masters: {id: @event_master.id})
                      .where("date_masters.date BETWEEN ? and ?", start_date, end_date)
                      .order(date: :desc)
                      .pluck(:date)

    render json: result_array
  end

  def list_event
    result_array = @merchandise_rate.event_masters.map{|em| [em.id, em.name, em.slug]}

    render json: result_array
  end

  private
  def set_event
    @event_master = EventMaster.find(params[:event_id])
  end

  def set_merchandise_rate
    @merchandise_rate = MerchandiseRate.find(params[:merchandise_rate_id])
  end
end
