class DropCoinLink < ActiveRecord::Migration[5.2]
  def change
    drop_table :coin_links
  end
end
