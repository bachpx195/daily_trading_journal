class AddRangeToCurrecyPair < ActiveRecord::Migration[5.2]
  def change
    add_column :currency_pairs, :range, :integer, default: 0
  end
end
