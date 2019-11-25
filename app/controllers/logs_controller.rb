class LogsController < ApplicationController
  before_action :find_log, except: [:index, :new, :create]
  before_action :list_logs, only: [:index, :destroy, :create]

  def index
    @logs = Log.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @log = Log.new
  end

  def create
    ActiveRecord::Base.transaction do
      if params[:log][:file_logs].present?
        @errors << "Please enter csv format" if params[:log][:file_logs].content_type != "text/html"

        @log_importer = LogImporter.new(
          params[:log][:file_logs]
        )

        @log_importer.execute
        @errors = @log_importer.errors
      end
    end
  
    respond_to do |format|
      @logs = Log.paginate(:page => params[:page], :per_page => 10)
      format.js {render layout: false}
    end
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
    params.require(:log).permit(:status, :result, :note, :datetime, :rating, :trade_id)
  end
end
