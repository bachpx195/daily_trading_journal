class CreateSystemConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :system_configs do |t|
      t.string :key
      t.float :value
      t.integer :value_type

      t.timestamps
    end
  end
end
