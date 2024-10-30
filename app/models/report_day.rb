class ReportDay < ApplicationRecord
  belongs_to :merchandise_rate
  belongs_to :analytic_day
end
