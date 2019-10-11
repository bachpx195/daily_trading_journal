class AddColumToCurrencyPair < ActiveRecord::Migration[5.2]
  def change
    add_column :currency_pairs, :liquid_rate, :integer, default: 0
    add_column :currency_pairs, :crosses_related, :string
    change_column_default :currency_pairs, :is_follow, 0
  end
end
