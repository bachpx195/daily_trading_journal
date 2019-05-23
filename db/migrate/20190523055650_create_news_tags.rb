class CreateNewsTags < ActiveRecord::Migration[5.2]
  def change
    create_table :news_tags do |t|
      t.references :new, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
