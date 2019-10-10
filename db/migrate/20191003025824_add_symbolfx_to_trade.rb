class AddSymbolfxToTrade < ActiveRecord::Migration[5.2]
  def change
    add_reference :trades, :currency_pair, index: true
  end
end
