class FundLogsController < ApplicationController
  before_action :set_fund_log, only: [:show, :edit, :update, :destroy]

  # GET /fund_logs
  # GET /fund_logs.json
  def index
    @fund = Fund.first


    @fund_logs = FundLog.all.order('created_at DESC')
  end

  # GET /fund_logs/1
  # GET /fund_logs/1.json
  def show
  end

  # GET /fund_logs/new
  def new
    @fund_log = FundLog.new
    respond_to do |format|
      format.html
      format.json
      format.js { render :layout => false }
    end
  end

  # GET /fund_logs/1/edit
  def edit
  end

  # POST /fund_logs
  # POST /fund_logs.json
  def create
    @fund_log = FundLog.new(fund_log_params)

    respond_to do |format|
      if @fund_log.save
        @fund_logs = FundLog.all.order('created_at DESC')
        format.js { render :layout => false }
      else
        format.js { render :layout => false }
      end
    end
  end

  # PATCH/PUT /fund_logs/1
  # PATCH/PUT /fund_logs/1.json
  def update
    respond_to do |format|
      if @fund_log.update(fund_log_params)
        format.html { redirect_to @fund_log, notice: 'Fund log was successfully updated.' }
        format.json { render :show, status: :ok, location: @fund_log }
      else
        format.html { render :edit }
        format.json { render json: @fund_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fund_logs/1
  # DELETE /fund_logs/1.json
  def destroy
    @fund_log.destroy
    respond_to do |format|
      format.html { redirect_to fund_logs_url, notice: 'Fund log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fund_log
      @fund_log = FundLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fund_log_params
      params.require(:fund_log).permit(:change_amount, :change_type)
    end
end
