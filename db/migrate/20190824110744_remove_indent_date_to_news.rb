class RemoveIndentDateToNews < ActiveRecord::Migration[5.2]
  def change
    remove_column :news, :intended_date
  end
end
