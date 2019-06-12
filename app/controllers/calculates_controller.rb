class CalculatesController < ApplicationController
  def index
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def create
    find_log_by_time params
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  private
  def find_log_by_time params
    if params[:type_of_calculate] == "date"
      date = params[:date].to_date
      @log_list = Log.get_logs_by_date(date)
	  elsif params[:type_of_calculate] == "month"
      date = params[:date].to_date
	   	@log_list = Log.get_logs_by_month(date.beginning_of_month, date.end_of_month)
	  else
	   	start_date = params[:start_date].to_date
  		end_date = params[:end_date].to_date
  		@log_list = Log.get_logs_by_month start_date, end_date
    end
    @logs = @log_list.paginate(:page => params[:page], :per_page => 10)
  end
end
