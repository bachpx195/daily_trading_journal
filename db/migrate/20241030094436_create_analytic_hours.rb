class CreateAnalyticHours < ActiveRecord::Migration[5.2]
  def change
    create_table :analytic_hours do |t|
      t.references :candlestick, foreign_key: true
      t.references :merchandise_rate, foreign_key: true
      t.references :analytic_day, foreign_key: true
      t.string :range_type
      t.date :date
      t.date :date_with_binane
      t.integer :hour
      t.float :return_oc
      t.float :return_hl
      t.string :candlestick_type
      t.boolean :is_same_btc
      t.integer :continue_by_day, default: 1
      t.integer :continue_by_hour, default: 1

      t.timestamps
    end
  end
end
