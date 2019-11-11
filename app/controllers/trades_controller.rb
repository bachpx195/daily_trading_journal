class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :edit, :update, :destroy, :close]
  before_action :delete_wrong_logs, except: [:close, :update]

  # GET /trades
  # GET /trades.json
  def index
    @q = Trade.includes(:trade_normal_method).search(params[:q])
    @trades = @q.result(distinct: true).order('created_at DESC')
  end

  # GET /trades/1
  # GET /trades/1.json
  def show
  end

  # GET /trades/new
  def new
    @trade = Trade.new
    @trade.trade_normal_method = @trade.build_trade_normal_method

    render :layout => false
  end

  # GET /trades/1/edit
  def edit
  end

  # POST /trades
  # POST /trades.json
  def create
    @trade = Trade.new(trade_params)

    respond_to do |format|
      if @trade.save
        @trades = Trade.includes(:trade_normal_method).order('created_at DESC')
        format.js { render :layout => false }
      else
        format.js { render :layout => false }
      end
    end
  end

  # PATCH/PUT /trades/1
  # PATCH/PUT /trades/1.json
  def update
    respond_to do |format|
      if @trade.update(trade_params)
        @trades = Trade.all.order('created_at DESC')
        format.js { render :layout => false }
      else
        format.js { render :layout => false }
      end
    end
  end

  # DELETE /trades/1
  # DELETE /trades/1.json
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
    # Use callbacks to share common setup or constraints between actions.
    def set_trade
      @trade = Trade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trade_params
      params.require(:trade)
        .permit(:currency_pair_id, :status, :start_date, :reason, :end_date, :order_type,
          trade_normal_method_attributes: [:id, :point_entry, :point_out, :stop_loss, :take_profit, :target, :fee, :amount],
          log_attributes: [:id, :note, :rating, :datetime, :money, :fee, :result, :status]
        )
    end
end
