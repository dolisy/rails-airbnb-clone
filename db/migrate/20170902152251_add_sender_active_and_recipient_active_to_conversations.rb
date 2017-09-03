class AddSenderActiveAndRecipientActiveToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :sender_active, :boolean
    add_column :conversations, :recipient_active, :boolean
  end
end
