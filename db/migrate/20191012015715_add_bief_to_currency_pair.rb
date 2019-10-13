class AddBiefToCurrencyPair < ActiveRecord::Migration[5.2]
  def change
    add_column :currency_pairs, :brief, :text
  end
end
