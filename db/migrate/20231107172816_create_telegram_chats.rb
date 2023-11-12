class CreateTelegramChats < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_chats do |t|
      t.string :name
      t.string :chat_id
      t.string :telegram_url

      t.timestamps
    end
  end
end
