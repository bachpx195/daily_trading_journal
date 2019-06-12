class CreateTradePyramidMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :trade_pyramid_methods do |t|
      t.references :trade_method, foreign_key: true
      t.references :trade, foreign_key: true

      t.timestamps
    end
  end
end
