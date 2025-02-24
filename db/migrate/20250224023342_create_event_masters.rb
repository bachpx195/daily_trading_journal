class CreateEventMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :event_masters do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :time
      t.text :note
      t.timestamps
    end
    add_index :event_masters, :slug
  end
end
