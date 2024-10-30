class CreateReportDays < ActiveRecord::Migration[5.2]
  def change
    create_table :report_days do |t|
      t.references :merchandise_rate, foreign_key: true
      t.references :analytic_day, foreign_key: true
      t.integer :highest_hour_return_oc
      t.integer :highest_hour_return_hl
      t.integer :highest_hour_volumn
      t.float :hour_range_33_per
      t.float :hour_range_67_per
      t.integer :reverse_increase_hour
      t.integer :reverse_decrease_hour
      t.integer :continue_increase_hour
      t.integer :continue_decrease_hour

      t.timestamps
    end
  end
end
