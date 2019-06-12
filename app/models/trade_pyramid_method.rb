class TradePyramidMethod < ApplicationRecord
  belongs_to :trade_method

  before_create :set_trade_method

  private
  def set_trade_method
    self.trade_method = 2
  end
end
