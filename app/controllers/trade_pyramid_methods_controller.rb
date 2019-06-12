class TradePyramidMethodsController < ApplicationController
  before_action :set_trade_pyramid_method, only: [:show, :edit, :update, :destroy]

  # GET /trade_pyramid_methods
  # GET /trade_pyramid_methods.json
  def index
    @trade_pyramid_methods = TradePyramidMethod.all
  end

  # GET /trade_pyramid_methods/1
  # GET /trade_pyramid_methods/1.json
  def show
  end

  # GET /trade_pyramid_methods/new
  def new
    @trade_pyramid_method = TradePyramidMethod.new
  end

  # GET /trade_pyramid_methods/1/edit
  def edit
  end

  # POST /trade_pyramid_methods
  # POST /trade_pyramid_methods.json
  def create
    @trade_pyramid_method = TradePyramidMethod.new(trade_pyramid_method_params)

    respond_to do |format|
      if @trade_pyramid_method.save
        format.html { redirect_to @trade_pyramid_method, notice: 'Trade pyramid method was successfully created.' }
        format.json { render :show, status: :created, location: @trade_pyramid_method }
      else
        format.html { render :new }
        format.json { render json: @trade_pyramid_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trade_pyramid_methods/1
  # PATCH/PUT /trade_pyramid_methods/1.json
  def update
    respond_to do |format|
      if @trade_pyramid_method.update(trade_pyramid_method_params)
        format.html { redirect_to @trade_pyramid_method, notice: 'Trade pyramid method was successfully updated.' }
        format.json { render :show, status: :ok, location: @trade_pyramid_method }
      else
        format.html { render :edit }
        format.json { render json: @trade_pyramid_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trade_pyramid_methods/1
  # DELETE /trade_pyramid_methods/1.json
  def destroy
    @trade_pyramid_method.destroy
    respond_to do |format|
      format.html { redirect_to trade_pyramid_methods_url, notice: 'Trade pyramid method was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade_pyramid_method
      @trade_pyramid_method = TradePyramidMethod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trade_pyramid_method_params
      params.require(:trade_pyramid_method).permit(:trade_method_id)
    end
end
