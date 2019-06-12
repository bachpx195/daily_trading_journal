class CreateTradeNormalMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :trade_normal_methods do |t|
      t.references :trade_method, foreign_key: true
      t.references :trade, foreign_key: true
      t.float :point_entry
      t.float :point_out
      t.float :stop_loss
      t.float :take_profit

      t.timestamps
    end
  end
end
