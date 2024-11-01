require 'date'

class AnalyticHour < ApplicationRecord  
  belongs_to :candlestick
  belongs_to :merchandise_rate
  belongs_to :analytic_day 
end
