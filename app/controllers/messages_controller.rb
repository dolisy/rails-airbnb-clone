class MessagesController < ApplicationController
  def index
    @messages = Message.all
    # @messages = []
    # Message.all.each do |message|
    #   if message.booking.user == current_user && message.message_type == "confirmed_message"
    #     @messages << message
    #   end

    #   if message.booking.user == current_user && message.message_type == "declined_message"
    #     @messages << message
    #   end

    #   if message.booking.book.library.user == current_user && message.message_type == "pending_message"
    #     @messages << message
    #   end
    # end
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    # @booking = Booking.find(params[:booking_id])
    @message = Message.new
  end

  def create
    # @booking = Booking.find(params[:booking_id])
    @message = Message.new(message_params)
    # @message.booking = @booking
    @message.save
    redirect_to messages_path
  end

  def pending
    @message = Message.find(params[:id])
    @message.subject = "You have a new request for #{@message.booking.book.title}"
    @message.save
    redirect_to book_booking_path(@message.booking.book, @message.booking)
  end

  private

  def message_params
    params.require(:message).permit(:subject, :content, :booking_id)
  end
end
