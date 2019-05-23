class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :url
      t.string :domain
      t.text :short_description
      t.string :tilte
      t.date :published_at
      t.integer :status
      t.date :intended_date
      t.references :new_category, foreign_key: true

      t.timestamps
    end
  end
end
