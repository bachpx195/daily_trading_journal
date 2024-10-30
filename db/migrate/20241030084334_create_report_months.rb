class CreateReportMonths < ActiveRecord::Migration[5.2]
  def change
    create_table :report_months do |t|
      t.references :merchandise_rate, foreign_key: true
      t.references :analytic_month, foreign_key: true
      t.date :highest_day_return_oc
      t.date :highest_day_return_hl
      t.date :highest_day_volumn
      t.float :day_range_33_per
      t.float :day_range_67_per
      t.date :reverse_increase_day
      t.date :reverse_decrease_day
      t.date :continue_increase_day
      t.date :continue_decrease_day

      t.timestamps
    end
  end
end
