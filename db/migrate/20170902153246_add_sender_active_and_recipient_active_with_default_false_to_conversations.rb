class AddSenderActiveAndRecipientActiveWithDefaultFalseToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :sender_active, :boolean, :default => false
    add_column :conversations, :recipient_active, :boolean, :default => false
  end
end
