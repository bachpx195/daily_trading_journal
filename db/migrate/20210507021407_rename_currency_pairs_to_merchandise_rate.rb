class RenameCurrencyPairsToMerchandiseRate < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :currency_pairs, :merchandise_rates
  end

  def self.down
    rename_table :merchandise_rates, :currency_pairs
  end
end
