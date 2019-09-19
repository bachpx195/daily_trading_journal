class AddNewsTypeToNews < ActiveRecord::Migration[5.2]
  def change
    add_column :news, :news_type, :integer, default: 0
  end
end
