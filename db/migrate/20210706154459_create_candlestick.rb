class CreateCandlestick < ActiveRecord::Migration[5.2]
  def change
    create_table :candlesticks do |t|
      t.references :merchandise_rate, foreign_key: true
      t.integer :time_type
      t.float :open
      t.float :high
      t.float :close
      t.float :low
      t.float :atr14
      t.datetime :date
      t.float :volumn

      t.timestamps
    end
  end
end
