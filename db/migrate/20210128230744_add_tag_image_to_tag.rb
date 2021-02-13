class AddTagImageToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :tag_image, :string
  end
end
