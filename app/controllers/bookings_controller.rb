class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def confirm
    @booking = Booking.find(params[:id])
    @booking.status = "accepted"
    @booking.save

    @private_message = PrivateMessage.new(
      conversation_id: @booking.conversation.id,
      body: "The reservation for #{@booking.book.title.truncate(55)} was accepted.",
      user_id: current_user.id,
      booking_id: @booking.id
    )
    @private_message.save

    redirect_to request.referer.present? ? request.referer : default_path
  end

  def decline
    @booking = Booking.find(params[:id])
    @booking.status = "declined"
    @booking.save

    @private_message = PrivateMessage.new(
      conversation_id: @booking.conversation.id,
      body: "The reservation for #{@booking.book.title.truncate(55)} was declined.",
      user_id: current_user.id,
      booking_id: @booking.id
    )
    @private_message.save

    redirect_to request.referer.present? ? request.referer : default_path
  end

  # def pending
  #   @booking = Booking.find(params[:id])
  #   @booking.status = "Pending"
  #   @booking.save

  #   @private_message = PrivateMessage.new(
  #     conversation_id: @booking.conversation.id,
  #     body: "#{@booking.user.email} is requesting #{@booking.book.title}",
  #     user_id: current_user.id,
  #     booking_id: @booking.id
  #   )
  #   @private_message.save

  #   redirect_to book_booking_path(@booking.book, @booking)
  # end

  def show
    @book = Book.find(params[:book_id])
    @booking = Booking.find(params[:id])

    @user = @booking.user

    # conversation

    @messages = Message.where(booking: @booking).sort_by{ |message| message.created_at }

    begin
      @conversation = Conversation.find_by!(sender_id: @booking.user.id, recipient_id: @booking.book.library.user.id)
    rescue
      @conversation = Conversation.find_or_create_by(sender_id: @booking.book.library.user.id, recipient_id: @booking.user.id)
    end

    @booking.conversation = @conversation

    @private_messages = @conversation.private_messages

    # if @private_messages.length > 10
    #   @over_ten = true
    #   @private_messages = @private_messages[-10..-1]
    # end

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
    @book = Book.find(params[:book_id])
    @user = current_user
    @booking = Booking.new(user: @user)
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.book = Book.find(params[:book_id])
    @booking.user = current_user

    begin
      @booking.conversation = Conversation.find_by!(sender_id: @booking.user.id, recipient_id: @booking.book.library.user.id)
    rescue
      @booking.conversation = Conversation.find_or_create_by(sender_id: @booking.book.library.user.id, recipient_id: @booking.user.id)
    end

    @booking.save

    @conversation = @booking.conversation
    @book = @booking.book

    @private_message = PrivateMessage.new
    respond_to do |format|
      format.js
    end

  end

  private

  def booking_params
    params.require(:booking).permit(:checkin_date, :checkout_date, :status, :user_id, :book_id)
  end
end
