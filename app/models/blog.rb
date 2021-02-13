class Blog < ApplicationRecord
  scope :sort_by_ASC, ->{order created_at: :asc}
  scope :sort_by_DESC, ->{order created_at: :desc}
  scope :sort_by_public_time, ->{order public_time: :desc}
  # after_create :check_public
  # after_update :check_public

  mount_uploader :intro_image, ImageUploader

  has_many :blog_tags, dependent: :destroy, inverse_of: :blog
  has_many :tags, through: :blog_tags

  accepts_nested_attributes_for :blog_tags, reject_if: proc { |attributes| attributes['tag_id'].blank? }

  validates :title, presence: true
  validates :public_time, presence: true
  validates_length_of :title, maximum: 255
  validates :intro_image, presence: true
  validate :image_size_validation, if: :intro_image?
  validate :file_format
  validates :content, presence: true

  enum public_status: {draft: 0, published: 1}

  def stop_public_blog
    update_attribute 'public_status', Blog.public_statuses[:draft]
  end

  def public_blog
    update_attribute 'public_status', Blog.public_statuses[:published]
  end

  def conditions_public_blog?
    return true if self.draft? && Time.now() > self.public_time
  end

  def check_public
    if Time.now() >= self.public_time
      self.public_blog
    else
      self.stop_public_blog
    end
  end

  private
  def image_size_validation
    if intro_image.size > 2.megabytes
      errors.add(:intro_image, "FIle so big")
    end
  end

  def file_format
    unless valid_extension? self.intro_image.filename
      errors.add(:intro_image, "File khong đúng format")
    end
  end

  def valid_extension? filename
    return true if filename.nil?
    ext = File.extname(filename)
    %w(.jpg .png).include? ext.downcase
  end
end
