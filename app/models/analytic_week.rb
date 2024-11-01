class AnalyticWeek < ApplicationRecord  
  has_one :report_week, dependent: :destroy

  belongs_to :candlestick
  belongs_to :merchandise_rate
  belongs_to :analytic_month
end
