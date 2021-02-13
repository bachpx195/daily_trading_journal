class CandlesticksController < ApplicationController
  before_action :set_merchandise_rate, only: [:index, :create]

  def index
    @q = Candlestick.search(params[:q])
    @candlesticks = @q.result(distinct: true).order('date DESC').paginate(:page => params[:page], :per_page => 50)
  end

  def create
    ActiveRecord::Base.transaction do
      if params[:candlestick][:file_json].present?

        @candlestick_importer = CandlestickImporter.new(
          @merchandise_rate,
          params[:candlestick][:file_json]
        )

        @candlestick_importer.execute
        @errors = @candlestick_importer.errors
      end
    end
    @candlesticks = @merchandise_rate.candlesticks.paginate(:page => params[:page], :per_page => 10)
    render 'index'
  end

  private
  def set_merchandise_rate
    @merchandise_rate = MerchandiseRate.find(params[:id])
  end

  def coin_link_params
    params.require(:coin_link).permit(:url, :kind, :coin)
  end
end
