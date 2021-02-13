class CandlesticksController < ApplicationController
<<<<<<< HEAD
  before_action :set_merchandise_rate, only: [:index, :create]

  def index
    @q = Candlestick.search(params[:q])
    @candlesticks = @q.result(distinct: true).order('date DESC').paginate(:page => params[:page], :per_page => 50)
=======
  # before_action :set_coin_link, only: [:show, :edit, :update, :destroy]
  before_action :set_currency_pair, only: [:index, :create]

  def index
    @q = Candlestick.search(params[:q])
    @candlesticks = @q.result(distinct: true).order('date ASC').paginate(:page => params[:page], :per_page => 10)
    # @candlesticks = @currency_pair.candlesticks.paginate(:page => params[:page], :per_page => 10)
>>>>>>> 612f21f (upload)
  end

  def create
    ActiveRecord::Base.transaction do
      if params[:candlestick][:file_json].present?

        @candlestick_importer = CandlestickImporter.new(
<<<<<<< HEAD
          @merchandise_rate,
=======
          @currency_pair,
>>>>>>> 612f21f (upload)
          params[:candlestick][:file_json]
        )

        @candlestick_importer.execute
        @errors = @candlestick_importer.errors
      end
    end
<<<<<<< HEAD
    @candlesticks = @merchandise_rate.candlesticks.paginate(:page => params[:page], :per_page => 10)
=======
    @candlesticks = @currency_pair.candlesticks.paginate(:page => params[:page], :per_page => 10)
>>>>>>> 612f21f (upload)
    render 'index'
  end

  private
<<<<<<< HEAD
  def set_merchandise_rate
    @merchandise_rate = MerchandiseRate.find(params[:id])
  end

=======
  # Use callbacks to share common setup or constraints between actions.
  def set_currency_pair
    @currency_pair = CurrencyPair.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
>>>>>>> 612f21f (upload)
  def coin_link_params
    params.require(:coin_link).permit(:url, :kind, :coin)
  end
end
