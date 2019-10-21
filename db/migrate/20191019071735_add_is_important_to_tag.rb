class AddIsImportantToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :is_follow, :integer, default: 0
  end
end