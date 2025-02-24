class CreateDateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :date_events do |t|
      t.references :date_master, foreign_key: true
      t.references :event_master, foreign_key: true

      t.timestamps
    end
  end
end
