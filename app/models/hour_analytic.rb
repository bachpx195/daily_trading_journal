class HourAnalytic < ApplicationRecord
  belongs_to :candlestick

  enum candlestick_type: {increase: 0, decrease: 1}

  # 7h-14h: buổi sáng, 15-19h: buổi chiều, 20h-23h: buổi tối, 0h-6h 
  # https://github.com/bachpx195/bach-s_trading_room/wiki/C%C3%A1c-phi%C3%AAn-giao-d%E1%BB%8Bch-trong-ng%C3%A0y
  enum day_session: {morning: 0, afternoon: 1, nigh: 2, mid_night: 3}
end
