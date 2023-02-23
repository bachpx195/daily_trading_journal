class BOrdersController < ApplicationController
  before_action :set_b_order, only: %i[ show edit update destroy ]

  # GET /b_orders or /b_orders.json
  def index
    @b_orders = BOrder.all
  end

  # GET /b_orders/1 or /b_orders/1.json
  def show
  end

  # GET /b_orders/new
  def new
    @b_order = BOrder.new
  end

  # GET /b_orders/1/edit
  def edit
  end

  # POST /b_orders or /b_orders.json
  def create
    @b_order = BOrder.new(b_order_params)

    respond_to do |format|
      if @b_order.save
        format.html { redirect_to b_order_url(@b_order), notice: "B order was successfully created." }
        format.json { render :show, status: :created, location: @b_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @b_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /b_orders/1 or /b_orders/1.json
  def update
    respond_to do |format|
      if @b_order.update(b_order_params)
        format.html { redirect_to b_order_url(@b_order), notice: "B order was successfully updated." }
        format.json { render :show, status: :ok, location: @b_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @b_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /b_orders/1 or /b_orders/1.json
  def destroy
    @b_order.destroy

    respond_to do |format|
      format.html { redirect_to b_orders_url, notice: "B order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_b_order
      @b_order = BOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def b_order_params
      params.require(:b_order).permit(:b_order_id, :merchandise_rate_id, :client_order, :price, :orig_qty, :executed_qty, :executed_quote_qty, :status, :type, :side, :insert_time, :update_time, :delegate_money, :avg_price, :orig_type, :position_side)
    end
end
