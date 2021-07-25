class Plans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status
      t.integer :category

      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true

      # optional fields
      t.integer :depth, :null => false, :default => 0
      t.integer :children_count, :null => false, :default => 0

      t.timestamps
    end
  end
end
