class CreatePlanMerchandiseRates < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_merchandise_rates do |t|
      t.references :merchandise_rate, foreign_key: true
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
