class AnalyticMonth < ApplicationRecord
  has_one :report_month, dependent: :destroy

  belongs_to :candlestick
  belongs_to :merchandise_rate
end
