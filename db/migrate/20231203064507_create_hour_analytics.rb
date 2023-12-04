class CreateHourAnalytics < ActiveRecord::Migration[5.2]
  def change
    create_table :hour_analytics do |t|
      t.references :candlestick, foreign_key: true
      t.date :date
      t.date :date_with_binane
      t.integer :hour
      t.float :return_oc
      t.float :return_hl
      t.integer :candlestick_type
      t.integer :range_type
      t.integer :highest_hour_return
      t.integer :reverse_increase_hour
      t.integer :reverse_decrease_hour
      t.boolean :is_same_btc
      t.integer :continue_by_day
      t.integer :continue_by_hour

      t.timestamps
    end
  end
end
