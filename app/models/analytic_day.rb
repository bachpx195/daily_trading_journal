class AnalyticDay < ApplicationRecord
  has_one :report_day, dependent: :destroy
  has_many :analytic_hours

  belongs_to :candlestick
  belongs_to :merchandise_rate
  belongs_to :analytic_month
  belongs_to :analytic_week
end
