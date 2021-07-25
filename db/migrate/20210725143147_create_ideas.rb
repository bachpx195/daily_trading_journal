class CreateIdeas < ActiveRecord::Migration[5.2]
  def change
    create_table :ideas do |t|
      t.string :title
      t.text :content
      t.string :brief
      t.string :image
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
