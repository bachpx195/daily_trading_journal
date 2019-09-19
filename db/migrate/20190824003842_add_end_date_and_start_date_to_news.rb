class AddEndDateAndStartDateToNews < ActiveRecord::Migration[5.2]
  def change
    add_column :news, :start_date, :datetime
    add_column :news, :end_date, :datetime
  end
end
