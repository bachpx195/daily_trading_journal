class CreateFunds < ActiveRecord::Migration[5.2]
  def change
    create_table :funds do |t|
      t.float :initial_capital
      t.float :present_value
      t.float :fee

      t.timestamps
    end
  end
end
