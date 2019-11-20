class AddOpenAndCloseTimeToLog < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :open_date, :datetime
    add_column :logs, :end_date, :datetime
  end
end
