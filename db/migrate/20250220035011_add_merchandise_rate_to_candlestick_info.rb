class AddMerchandiseRateToCandlestickInfo < ActiveRecord::Migration[5.2]
  def change
    add_reference :candlestick_infos, :merchandise_rate, foreign_key: true, after: :candlestick_id
  end
end
