class MessagesController < ApplicationController
  def index
    @messages = []
    Message.all.each do |message|
      if message.booking.user == current_user && message.message_type == "confirmed_message"
        @messages << message
      end

      if message.booking.user == current_user && message.message_type == "declined_message"
        @messages << message
      end

      if message.booking.book.library.user == current_user && message.message_type == "pending_message"
        @messages << message
      end
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.save
    redirect_to messages_path
  end

  private

  def message_params
    params.require(:message).permit(:subject, :content, :booking_id)
  end
end
