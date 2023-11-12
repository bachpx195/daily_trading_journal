class RenameSymbolfxesToMmerchandise < ActiveRecord::Migration[5.2]
  def self.up
    # rename_table :symbolfxes, :merchandise
  end

  def self.down
    # rename_table :merchandise, :symbolfxes
  end
end
