class Merchandise < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :merchandise_rates, -> (object) { where("select * from merchandise_rates where merchandise_rates.base_id = ?", object.id) }, class_name: "MerchandiseRate"
  belongs_to :tag
end
