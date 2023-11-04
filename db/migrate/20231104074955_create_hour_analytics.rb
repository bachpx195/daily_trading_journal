class CreateHourAnalytics < ActiveRecord::Migration[5.2]
  def change
    create_table :hour_analytics do |t|
      t.references :candlestick, foreign_key: true
      t.date :date
      t.integer :hour
      t.float :return_oc
      t.float :return_hl
      t.integer :candlestick_type
      t.integer :is_highest_return
      t.integer :is_lowest_return
      t.integer :day_session

      t.timestamps
    end
  end
end
