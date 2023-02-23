class CreateBOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :b_orders do |t|
      t.integer :b_order_id
      t.references :merchandise_rate, foreign_key: true
      t.string :client_order
      t.float :price
      t.float :orig_qty
      t.float :executed_qty
      t.float :executed_quote_qty
      t.integer :status
      t.integer :type
      t.integer :side
      t.date :insert_time
      t.date :update_time
      t.float :delegate_money
      t.float :avg_price
      t.integer :orig_type
      t.integer :position_side
      t.float :profit
      t.float :fee

      t.timestamps
    end
  end
end
