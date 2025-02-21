class CreateCandlestickInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :candlestick_infos do |t|
      t.references :candlestick, foreign_key: true
      t.references :group_candlestick, foreign_key: true

      t.timestamps
    end
  end
end
