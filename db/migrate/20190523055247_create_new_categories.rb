class CreateNewCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :new_categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
