class Api::V1::BaseApiController < ActionController::Base
  skip_before_action :verify_authenticity_token
end
