class ChangeTypeSystemConfig < ActiveRecord::Migration[5.2]
  def change
    change_column :system_configs, :value, :string
  end
end
