class Candlestick < ApplicationRecord
  belongs_to :currency_pair

  enum time_type: {day: 1}
end
