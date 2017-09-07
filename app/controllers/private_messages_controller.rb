class PrivateMessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @private_messages = @conversation.private_messages
    if @private_messages.length > 10
      @over_ten = true
      @private_messages = @private_messages[-10..-1]
    end

    if params[:m]
      @over_ten = false
      @private_messages = @conversation.private_messages
    end

    if @private_messages.last
      if @private_messages.last.user_id != current_user.id
        @private_messages.last.read = true;
      end
    end

    @private_message = @conversation.private_messages.new
  end

  def new
    @private_message = @conversation.private_messages.new
  end

  def create
    @private_message = @conversation.private_messages.new(private_message_params)

    if @private_message.save
      # redirect_to conversation_private_messages_path(@conversation)

      if @private_message.booking
        redirect_to [@private_message.booking.book, @private_message.booking]
      else
        redirect_to request.referer.present? ? request.referer : default_path
      end

    end
  end

  private

  def private_message_params
    params.require(:private_message).permit(:body, :user_id, :booking_id)
  end
end
