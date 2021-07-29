class AddDefaultToIdea < ActiveRecord::Migration[5.2]
  def change
    change_column_default :ideas, :status, 0
  end
end
