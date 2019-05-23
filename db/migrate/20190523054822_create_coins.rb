class CreateCoins < ActiveRecord::Migration[5.2]
  def change
    create_table :coins do |t|
      t.string :slug
      t.string :title
      t.text :description
      t.string :code
      t.integer :rank
      t.string :meta_title
      t.float :market_cap_usd
      t.float :price_usd
      t.references :coin_category, foreign_key: true

      t.timestamps
    end
  end
end
