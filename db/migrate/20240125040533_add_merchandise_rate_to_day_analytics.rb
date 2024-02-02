class AddMerchandiseRateToDayAnalytics < ActiveRecord::Migration[5.2]
  def change
    add_reference :day_analytics, :merchandise_rate, foreign_key: true, after: :candlestick_id
  end
end
