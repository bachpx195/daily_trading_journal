class Candlestick < ApplicationRecord
  belongs_to :merchandise_rate

  enum time_type: {day: 1}
end
