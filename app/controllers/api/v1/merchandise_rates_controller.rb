class Api::V1::MerchandiseRatesController < ApplicationController
  def index
    @merchandise_rates = MerchandiseRate.crypto_currencies
  end
end
