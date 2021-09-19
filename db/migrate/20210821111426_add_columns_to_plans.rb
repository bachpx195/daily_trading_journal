class AddColumnsToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :plan_image, :string
  end
end
