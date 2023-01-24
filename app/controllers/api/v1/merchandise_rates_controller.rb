class Api::V1::MerchandiseRatesController < Api::V1::BaseApiController
  def index
    @merchandise_rates = MerchandiseRate.crypto_currencies
  end
end
