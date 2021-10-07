class Candlestick < ApplicationRecord
  belongs_to :merchandise_rate

  enum time_type: {day: 1, week: 2, month: 3, hour: 4}
end
