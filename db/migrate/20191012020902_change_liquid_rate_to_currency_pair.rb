class ChangeLiquidRateToCurrencyPair < ActiveRecord::Migration[5.2]
  def change
  	change_column :currency_pairs, :liquid_rate, :string
  end
end
