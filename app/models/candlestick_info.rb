class CandlestickInfo < ApplicationRecord
  belongs_to :candlestick
  belongs_to :group_candlestick, optional: true
  belongs_to :parent_candlestick, class_name: 'Candlestick', foreign_key: 'parent_id', optional: true
end
