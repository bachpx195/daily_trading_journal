class CreateAnalyticWeeks < ActiveRecord::Migration[5.2]
  def change
    create_table :analytic_weeks do |t|
      t.references :candlestick, foreign_key: true
      t.references :merchandise_rate, foreign_key: true
      t.references :analytic_month, foreign_key: true
      t.integer :month
      t.integer :year
      t.date :from_date
      t.date :to_date
      t.string :candlestick_type
      t.string :range_type
      t.float :return_oc
      t.float :return_hl
      t.boolean :is_inside_week
      t.boolean :is_same_btc
      t.boolean :is_continue_increase
      t.boolean :is_continue_decrease
      t.boolean :is_fake_breakout_increase
      t.boolean :is_fake_breakout_decrease
      t.integer :continue_by_week, default: 1

      t.timestamps
    end
  end
end
