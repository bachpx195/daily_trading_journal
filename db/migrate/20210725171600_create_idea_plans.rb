class CreateIdeaPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :idea_plans do |t|
      t.references :idea, foreign_key: true
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
