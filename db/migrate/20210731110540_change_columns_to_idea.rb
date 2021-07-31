class ChangeColumnsToIdea < ActiveRecord::Migration[5.2]
  def change
    change_column_default :ideas, :rating, 3
  end
end
