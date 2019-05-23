class CreateCoinLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :coin_links do |t|
      t.string :url
      t.string :kind
      t.references :coin, foreign_key: true

      t.timestamps
    end
  end
end
