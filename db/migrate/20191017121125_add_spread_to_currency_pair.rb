class AddSpreadToCurrencyPair < ActiveRecord::Migration[5.2]
  def change
    add_column :currency_pairs, :spread, :integer, default: 0
  end
end
