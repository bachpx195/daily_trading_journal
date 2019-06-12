class CreateTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :trades do |t|
      t.references :coin, foreign_key: true
      t.integer :status
      t.datetime :start_date
      t.datetime :end_date
      t.text :reason

      t.timestamps
    end
  end
end
