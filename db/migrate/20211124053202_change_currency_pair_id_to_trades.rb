class ChangeCurrencyPairIdToTrades < ActiveRecord::Migration[5.2]
  def change
    add_reference :trades, :merchandise_rate, index: true
  end
end
