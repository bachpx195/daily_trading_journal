class AddMarketTypeToWiki < ActiveRecord::Migration[5.2]
  def change
    add_column :wikis, :market_type, :integer, null: false, default: 0
  end
end
