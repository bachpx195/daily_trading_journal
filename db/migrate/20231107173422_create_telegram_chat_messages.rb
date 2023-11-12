class CreateTelegramChatMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_chat_messages do |t|
      t.references :telegram_chat
      t.string :msg_id
      t.text :content
      t.datetime :chat_date

      t.timestamps
    end
  end
end
