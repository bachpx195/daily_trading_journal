class PlanMerchandise < ApplicationRecord
  belongs_to :merchandise
  belongs_to :plan
end
