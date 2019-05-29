class TagsGroup < ApplicationRecord
  belongs_to :group
  belongs_to :tag
end
