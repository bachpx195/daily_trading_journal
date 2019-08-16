class CreateGlossaries < ActiveRecord::Migration[5.2]
  def change
    create_table :glossaries do |t|
      t.string :title
      t.text :brief
      t.text :content

      t.timestamps
    end
  end
end
