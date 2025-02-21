class AddParentIdToCandlestickInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :candlestick_infos, :parent_id, :integer
  end
end
