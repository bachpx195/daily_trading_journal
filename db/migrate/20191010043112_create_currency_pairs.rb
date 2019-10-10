class CreateCurrencyPairs < ActiveRecord::Migration[5.2]
  def change
    create_table :currency_pairs do |t|
      t.string :name
      t.string :slug
      t.integer :base_id
      t.integer :quote_id
      t.float :winrate
      t.text :desciption
      t.integer :is_follow
      t.references :tag, foreign_key: true
  
      t.timestamps
    end
  end
end
