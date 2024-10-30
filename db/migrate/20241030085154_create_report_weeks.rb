class CreateReportWeeks < ActiveRecord::Migration[5.2]
  def change
    create_table :report_weeks do |t|
      t.references :merchandise_rate, foreign_key: true
      t.references :analytic_week, foreign_key: true
      t.date :highest_day_return_oc
      t.string :highest_day_return_hl_name
      t.date :highest_day_return_hl
      t.string :highest_day_return_hl_name
      t.date :highest_day_volumn
      t.string :highest_day_volumn_name
      t.float :day_range_33_per
      t.float :day_range_67_per
      t.date :reverse_increase_day
      t.string :reverse_increase_day_name
      t.date :reverse_decrease_day
      t.string :reverse_decrease_day_name
      t.date :continue_increase_day
      t.string :continue_increase_day_name
      t.date :continue_decrease_day
      t.string :continue_decrease_day_name

      t.timestamps
    end
  end
end
