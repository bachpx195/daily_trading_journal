class CreateCoins < ActiveRecord::Migration[5.2]
  def change
    create_table :coins do |t|
      t.string :slug
      t.string :title
      t.text :description
      t.string :code
      t.integer :rank
      t.integer :is_follow, default: 0
      t.string :meta_title
      t.string :platform
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
