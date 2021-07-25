class PlanMerchandiseRate < ApplicationRecord
  belongs_to :merchandise_rate
  belongs_to :plan
end
