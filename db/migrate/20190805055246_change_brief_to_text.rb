class ChangeBriefToText < ActiveRecord::Migration[5.2]
  def change
  	change_column :wikis, :brief, :text
  end
end
