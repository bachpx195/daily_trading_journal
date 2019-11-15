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

  def import_logs
    ActiveRecord::Base.transaction do
      if params[:file_logs].present?
        @error_branches << "Please enter csv format" if params[:file_branches].content_type != "text/csv"
        @branch_importer = BranchImporter.new(
          @company,
          params[:file_branches]
        )
        @branch_importer.execute
        @branches = @branch_importer.branches
        @error_branches = @branch_importer.errors
        notice << 'Branches'
      end
    end
  
    respond_to do |format|
      if @error_positions.present? || @error_branches.present? || @error_images.present?
        format.html { render :upload_csv }
      else
        format.html { redirect_to upload_csv_company_path, notice: "#{notice.join(',')} were successfully imported." }
      end
    end
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
