class TradeMethodsController < ApplicationController
  before_action :set_trade_method, only: [:show, :edit, :update, :destroy]

  # GET /trade_methods
  # GET /trade_methods.json
  def index
    @trade_methods = TradeMethod.all
  end

  # GET /trade_methods/1
  # GET /trade_methods/1.json
  def show
  end

  # GET /trade_methods/new
  def new
    @trade_method = TradeMethod.new
  end

  # GET /trade_methods/1/edit
  def edit
  end

  # POST /trade_methods
  # POST /trade_methods.json
  def create
    @trade_method = TradeMethod.new(trade_method_params)

    respond_to do |format|
      if @trade_method.save
        format.html { redirect_to @trade_method, notice: 'Trade method was successfully created.' }
        format.json { render :show, status: :created, location: @trade_method }
      else
        format.html { render :new }
        format.json { render json: @trade_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trade_methods/1
  # PATCH/PUT /trade_methods/1.json
  def update
    respond_to do |format|
      if @trade_method.update(trade_method_params)
        format.html { redirect_to @trade_method, notice: 'Trade method was successfully updated.' }
        format.json { render :show, status: :ok, location: @trade_method }
      else
        format.html { render :edit }
        format.json { render json: @trade_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trade_methods/1
  # DELETE /trade_methods/1.json
  def destroy
    @trade_method.destroy
    respond_to do |format|
      format.html { redirect_to trade_methods_url, notice: 'Trade method was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade_method
      @trade_method = TradeMethod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trade_method_params
      params.require(:trade_method).permit(:name, :win_rate, :rule)
    end
end
