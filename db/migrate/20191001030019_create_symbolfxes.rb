class CreateSymbolfxes < ActiveRecord::Migration[5.2]
  def change
    create_table :merchandises do |t|
      t.string :name
      t.string :slug
      t.string :base
      t.string :quote
      t.float :winrate
      t.text :desciption
      t.integer :is_follow
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
