class Candlestick < ApplicationRecord
  belongs_to :merchandise_rate
  enum time_type: {day: 1, week: 2, month: 3, hour: 4, m15: 5}

  class << self
    def delete_duplicate
      Candlestick.where.not(id: Candlestick.group(:date, :time_type, :merchandise_rate_id).select("min(id)")).destroy_all
    end
  end
end
