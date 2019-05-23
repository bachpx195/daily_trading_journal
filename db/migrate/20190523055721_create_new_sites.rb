class CreateNewSites < ActiveRecord::Migration[5.2]
  def change
    create_table :new_sites do |t|
      t.string :domanin
      t.text :description

      t.timestamps
    end
  end
end
