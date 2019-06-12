class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.integer :status
      t.float :result
      t.text :note
      t.float :money
      t.datetime :datetime
      t.integer :period_time
      t.integer :rating
      t.references :trade, foreign_key: true

      t.timestamps
    end
  end
end
