class CreateCoinSources < ActiveRecord::Migration[5.2]
  def change
    create_table :coin_sources do |t|
      t.string :title
      t.string :domain_slug
      t.string :website
      t.references :coin, foreign_key: true

      t.timestamps
    end
  end
end
