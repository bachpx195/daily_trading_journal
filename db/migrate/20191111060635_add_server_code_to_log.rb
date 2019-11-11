class AddServerCodeToLog < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :server_code, :string
  end
end
