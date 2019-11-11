class AddOrderTypeToTrade < ActiveRecord::Migration[5.2]
  def change
    add_column :trades, :order_type, :integer
  end
end
