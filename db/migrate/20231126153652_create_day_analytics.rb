class CreateDayAnalytics < ActiveRecord::Migration[5.2]
  def change
    create_table :day_analytics do |t|
      t.references :candlestick, foreign_key: true
      t.date :date
      t.string :date_name
      t.float :return_oc
      t.float :return_hl
      t.integer :candlestick_type
      t.integer :range_type
      t.boolean :is_inside_day
      t.integer :highest_hour_return
      t.integer :reverse_increase_hour
      t.integer :reverse_decrease_hour
      t.boolean :is_fake_breakout_increase
      t.boolean :is_fake_breakout_decrease
      t.boolean :is_same_btc

      t.timestamps
    end
  end
end
