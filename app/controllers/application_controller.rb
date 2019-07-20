class ApplicationController < ActionController::Base
	before_action :authenticate_user!
  
  def delete_wrong_logs
    Log.where("datetime is null")&.destroy_all
  end
end
