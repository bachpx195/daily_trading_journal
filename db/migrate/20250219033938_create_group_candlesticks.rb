class CreateGroupCandlesticks < ActiveRecord::Migration[5.2]
  def change
    create_table :group_candlesticks do |t|
      t.references :candlestick, foreign_key: true
      t.integer :candlestick_count

      t.timestamps
    end
  end
end
