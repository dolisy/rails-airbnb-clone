class PrivateMessage < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  belongs_to :booking
  validates_presence_of :body, :conversation_id, :user_id

  def private_message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end
