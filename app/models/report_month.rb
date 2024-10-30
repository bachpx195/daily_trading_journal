class ReportMonth < ApplicationRecord
  belongs_to :merchandise_rate
  belongs_to :analytic_month
end
