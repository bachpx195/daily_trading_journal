class Api::V1::PlansController < ApplicationController
  def show
    @plans = Plan.order(:lft)
  end
end
