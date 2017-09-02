class RemoveSenderActiveAndRecipientActiveFromConversations < ActiveRecord::Migration[5.0]
  def change
    remove_column :conversations, :sender_active, :boolean
    remove_column :conversations, :recipient_active, :boolean
  end
end
