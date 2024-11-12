class CreateDateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :date_events do |t|
      t.date :date
      t.integer :date_number
      t.string :day_name
      t.integer :month
      t.integer :year
      t.string :event_name
      t.string :event_time
      t.text :note

      t.timestamps
    end
  end
end
