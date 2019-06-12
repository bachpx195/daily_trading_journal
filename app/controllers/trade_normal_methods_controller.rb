class TradeNormalMethodsController < ApplicationController
  before_action :set_trade_normal_method, only: [:show, :edit, :update, :destroy]

  # GET /trade_normal_methods
  # GET /trade_normal_methods.json
  def index
    @trade_normal_methods = TradeNormalMethod.all
  end

  # GET /trade_normal_methods/1
  # GET /trade_normal_methods/1.json
  def show
  end

  # GET /trade_normal_methods/new
  def new
    @trade_normal_method = TradeNormalMethod.new
  end

  # GET /trade_normal_methods/1/edit
  def edit
  end

  # POST /trade_normal_methods
  # POST /trade_normal_methods.json
  def create
    @trade_normal_method = TradeNormalMethod.new(trade_normal_method_params)

    respond_to do |format|
      if @trade_normal_method.save validate: false
        format.html { redirect_to @trade_normal_method, notice: 'Trade normal method was successfully created.' }
        format.json { render :show, status: :created, location: @trade_normal_method }
      else
        format.html { render :new }
        format.json { render json: @trade_normal_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trade_normal_methods/1
  # PATCH/PUT /trade_normal_methods/1.json
  def update
    respond_to do |format|
      if @trade_normal_method.update(trade_normal_method_params)
        format.html { redirect_to @trade_normal_method, notice: 'Trade normal method was successfully updated.' }
        format.json { render :show, status: :ok, location: @trade_normal_method }
      else
        format.html { render :edit }
        format.json { render json: @trade_normal_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trade_normal_methods/1
  # DELETE /trade_normal_methods/1.json
  def destroy
    @trade_normal_method.destroy
    respond_to do |format|
      format.html { redirect_to trade_normal_methods_url, notice: 'Trade normal method was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade_normal_method
      @trade_normal_method = TradeNormalMethod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trade_normal_method_params
      params.require(:trade_normal_method).permit(:point_entry, :point_out, :stop_loss, :take_profit)
    end
end
