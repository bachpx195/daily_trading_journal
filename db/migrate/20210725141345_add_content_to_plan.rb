class AddContentToPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :content, :text
  end
end
