class CreateDateMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :date_masters do |t|
      t.date :date
      t.string :date_name
      t.integer :date_number
      t.integer :month
      t.integer :year
      t.text :note
      t.integer :event_count
      t.references :week_master, foreign_key: true

      t.timestamps
    end
    add_index :date_masters, :date
  end
end
