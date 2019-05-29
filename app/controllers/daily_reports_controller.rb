class DailyReportsController < ApplicationController
  before_action :set_daily_report, only: [:show, :edit, :update, :destroy]

  # GET /daily_reports
  # GET /daily_reports.json
  def index
    @daily_reports = DailyReport.all
  end

  # GET /daily_reports/1
  # GET /daily_reports/1.json
  def show
  end

  # GET /daily_reports/new
  def new
    @daily_report = DailyReport.new
  end

  # GET /daily_reports/1/edit
  def edit
  end

  # POST /daily_reports
  # POST /daily_reports.json
  def create
    @daily_report = DailyReport.new(daily_report_params)

    respond_to do |format|
      if @daily_report.save
        format.html { redirect_to @daily_report, notice: 'Daily report was successfully created.' }
        format.json { render :show, status: :created, location: @daily_report }
      else
        format.html { render :new }
        format.json { render json: @daily_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_reports/1
  # PATCH/PUT /daily_reports/1.json
  def update
    respond_to do |format|
      if @daily_report.update(daily_report_params)
        format.html { redirect_to @daily_report, notice: 'Daily report was successfully updated.' }
        format.json { render :show, status: :ok, location: @daily_report }
      else
        format.html { render :edit }
        format.json { render json: @daily_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_reports/1
  # DELETE /daily_reports/1.json
  def destroy
    @daily_report.destroy
    respond_to do |format|
      format.html { redirect_to daily_reports_url, notice: 'Daily report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_report
      @daily_report = DailyReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_report_params
      params.require(:daily_report).permit(:date, :coin, :new, :result)
    end
end
