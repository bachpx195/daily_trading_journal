class CreateFunds < ActiveRecord::Migration[5.2]
  def change
    create_table :funds do |t|
      t.float :initial_capital
      t.float :present_value
      t.float :future_value
      t.float :desposit
      t.float :withdraw
      t.float :rate_of_growth

      t.timestamps
    end
  end
end
