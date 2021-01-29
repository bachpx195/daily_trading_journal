class Tag < ApplicationRecord
  acts_as_nested_set

  UPDATABLE_ATTRIBUTES = [:title, :slug, :content, :new_position, :parent_id, :tag_image]

  has_many :news_tags
  has_many :news, through: :news_tags
  has_many :blog_tags
  has_many :blogs, through: :blog_tags
  has_many :coins
  has_many :symbolfxes
  has_many :currency_pairs
  has_many :wikis
  has_many :news_sites

  enum is_follow: {unfollow: 0, followed: 1}

  mount_uploader :tag_image, ImageUploader

  def parent_id= parent_id
    if parent_id == "#"
      move_to_root
    else
      super parent_id
    end
  end

  def new_position= new_position
    if parent.blank?
      prev_node = root.siblings[new_position.to_i - 1]
      move_to_right_of prev_node
    else
      move_to_child_with_index parent, new_position.to_i
      parent.reload
    end
  end
end
