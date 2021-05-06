class AddVolumnToCandlestick < ActiveRecord::Migration[5.2]
  def change
    add_column :candlesticks, :volumn, :float
  end
end
