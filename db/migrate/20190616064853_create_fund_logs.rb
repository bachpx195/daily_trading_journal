class CreateFundLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :fund_logs do |t|
      t.float :change_amount
      t.integer :change_type

      t.timestamps
    end
  end
end
