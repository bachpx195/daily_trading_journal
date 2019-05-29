class CreateNewsSites < ActiveRecord::Migration[5.2]
  def change
    create_table :news_sites do |t|
      t.string :domain
      t.text :description
	  t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
