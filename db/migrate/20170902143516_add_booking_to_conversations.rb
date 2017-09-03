class AddBookingToConversations < ActiveRecord::Migration[5.0]
  def change
    add_reference :conversations, :booking, foreign_key: true
  end
end
