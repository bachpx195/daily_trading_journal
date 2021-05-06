class DropMerchandiseRatesTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :merchandise_rates
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
