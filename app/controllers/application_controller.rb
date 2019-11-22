class ApplicationController < ActionController::Base
	before_action :authenticate_user!
  
  def delete_wrong_logs
    logs = Log.where("datetime is null")
    
    if logs.present?
      fl = FundLog.where(log_id: logs.pluck(:id))
      fl.delete_all if fl.present?
      logs.delete_all
    end
  end
end
