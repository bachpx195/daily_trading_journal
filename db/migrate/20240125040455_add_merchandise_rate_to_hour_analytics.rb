class AddMerchandiseRateToHourAnalytics < ActiveRecord::Migration[5.2]
  def change
    add_reference :hour_analytics, :merchandise_rate, foreign_key: true, after: :candlestick_id
  end
end
