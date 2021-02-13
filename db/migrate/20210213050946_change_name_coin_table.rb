class ChangeNameCoinTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :symbolfxes, :merchandises
  end
end
