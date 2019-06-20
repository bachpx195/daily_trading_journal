class CreateFundLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :fund_logs do |t|
      t.references :log, foreign_key: true
      t.float :change_amount
      t.integer :change_type

      t.timestamps
    end
  end
end
