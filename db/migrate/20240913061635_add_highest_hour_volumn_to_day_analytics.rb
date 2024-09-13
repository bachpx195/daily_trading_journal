class AddHighestHourVolumnToDayAnalytics < ActiveRecord::Migration[5.2]
  def change
    add_column :day_analytics, :highest_hour_volumn, :integer, after: :highest_hour_return
  end
end
