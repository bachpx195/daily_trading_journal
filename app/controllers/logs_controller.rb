class LogsController < ApplicationController
  before_action :find_log, except: [:index, :new, :create]
  before_action :list_logs, only: [:index, :destroy, :create]

  def index
    @logs = Log.paginate(:page => params[:page], :per_page => 10)
  end

  def update
    @log.update_attributes log_params
    @logs = Log.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def edit
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def show
  end

  private
  def find_log
    @log = Log.find_by id: params[:id]
  end

  def list_logs
    @title = "Nhật kí trade"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def log_params
    params.require(:log).permit(:status, :result, :note, :datetime, :period_time, :rating, :trade_id)
  end
end
