class CreatePlanMerchandises < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_merchandises do |t|
      t.references :merchandise, foreign_key: true
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
