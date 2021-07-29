class Idea < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :idea_plans
  has_many :plans, through: :idea_plans
  has_many :idea_merchandises
  has_many :merchandises, through: :idea_merchandises

  accepts_nested_attributes_for :idea_merchandises, allow_destroy: true
  accepts_nested_attributes_for :idea_plans, allow_destroy: true

  belongs_to :tag

  mount_uploader :image, ImageUploader
  enum status: {draft: 0, open: 1, close: 2}
end
