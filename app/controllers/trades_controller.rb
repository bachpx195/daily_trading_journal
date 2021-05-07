class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :edit, :update, :destroy, :close]
  before_action :delete_wrong_logs, except: [:close, :update]

  def index
    @q = Trade.includes(:trade_normal_method, :merchandise_rate).search(params[:q])
    @trades = @q.result(distinct: true).order('start_date DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def show
  end

  def new
    @trade = Trade.new
    @trade.trade_normal_method = @trade.build_trade_normal_method

    render :layout => false
  end

  def edit
  end

  def create
    @trade = Trade.new(trade_params)

    respond_to do |format|
      if @trade.save
        @trades = Trade.includes(:trade_normal_method, :merchandise_rate).order('start_date DESC').paginate(:page => params[:page], :per_page => 10)
        format.js { render :layout => false }
      else
        format.js { render :layout => false }
      end
    end
  end

  def update
    respond_to do |format|
      if @trade.update(trade_params)
        @trades = Trade.includes(:trade_normal_method, :merchandise_rate).order('start_date DESC').paginate(:page => params[:page], :per_page => 10)
        format.js { render :layout => false }
      else
        format.js { render :layout => false }
      end
    end
  end

  def destroy
    @trade.destroy
    respond_to do |format|
      format.html { redirect_to trades_url, notice: 'Trade was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def close
    @trade.log = Log.find_or_initialize_by(trade_id: @trade.id)
    @trade_method = @trade.trade_normal_method
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private
    def set_trade
      @trade = Trade.find(params[:id])
    end

    def trade_params
      params.require(:trade)
        .permit(:merchandise_rate_id, :status, :start_date, :reason, :end_date, :order_type,
          trade_normal_method_attributes: [:id, :point_entry, :point_out, :stop_loss, :take_profit, :target, :fee, :amount],
          log_attributes: [:id, :note, :rating, :datetime, :money, :fee, :result, :status]
        )
    end
end
