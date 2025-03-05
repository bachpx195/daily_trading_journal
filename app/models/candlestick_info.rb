class CandlestickInfo < ApplicationRecord
  belongs_to :candlestick
  belongs_to :group_candlestick, optional: true
  belongs_to :parent_candlestick, class_name: 'Candlestick', foreign_key: 'parent_id', optional: true

  class << self
    def create_parent_id
      null_parent_ids = CandlestickInfo.where(parent_id: nil).pluck(:candlestick_id)
      HourAnalytic.where(candlestick_id: null_parent_ids).pluck(:date_with_binane, :candlestick_id, :merchandise_rate_id).each do |ha|
        parent_id = DayAnalytic.where(merchandise_rate_id: ha[2], date: ha[0]).first&.id
        if parent_id.present?
          Rails.logger.info ha[0]
          ci = CandlestickInfo.find_by(candlestick_id: ha[1])
          ci.update(parent_id: parent_id) if ci.present?
        end
      end
    end
  end
end
