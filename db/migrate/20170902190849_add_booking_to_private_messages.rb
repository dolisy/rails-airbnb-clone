class AddBookingToPrivateMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :private_messages, :booking, foreign_key: true
  end
end
