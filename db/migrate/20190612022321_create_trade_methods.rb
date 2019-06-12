class CreateTradeMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :trade_methods do |t|
      t.string :name
      t.float :win_rate
      t.text :rule

      t.timestamps
    end
  end
end
