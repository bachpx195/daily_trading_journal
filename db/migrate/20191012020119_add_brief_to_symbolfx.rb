class AddBriefToSymbolfx < ActiveRecord::Migration[5.2]
  def change
    add_column :symbolfxes, :brief, :text
  end
end
