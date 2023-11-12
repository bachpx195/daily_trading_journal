class RenameMerchandiseTable < ActiveRecord::Migration[5.2]
  def self.up
    # rename_table :merchandise, :merchandises
  end

  def self.down
    # rename_table :merchandises, :merchandise
  end
end
