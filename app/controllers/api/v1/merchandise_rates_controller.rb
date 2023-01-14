class Api::V1::MerchandiseRatesController < ApplicationController
  def index
    @merchandise_rates = MerchandiseRate.all
  end
end
