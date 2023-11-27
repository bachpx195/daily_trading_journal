class DayAnalytic < ApplicationRecord
  belongs_to :candlestick

  enum candlestick_type: {increase: 0, decrease: 1}
  # - 0.9 <= sideway <= 0.9
  # 0.9 < increase_type <= 4
  # -4 <= decrease_type < -0.9
  # increase_strong > 4
  # decrease_strong < -4
  enum range_type: {increase_strong: 0, increase_type: 1, sideway: 2, decrease_type: 3, decrease_strong: 4}
end
