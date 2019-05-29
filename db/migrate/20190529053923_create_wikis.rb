class CreateWikis < ActiveRecord::Migration[5.2]
  def change
    create_table :wikis do |t|
      t.string :title
      t.text :content
      t.string :brief
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
