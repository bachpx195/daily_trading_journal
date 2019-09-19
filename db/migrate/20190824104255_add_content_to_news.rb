class AddContentToNews < ActiveRecord::Migration[5.2]
  def change
    add_column :news, :content, :text
    remove_column :news, :domain
  end
end
