class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def confirm
    @booking = Booking.find(params[:id])
    @booking.status = "Confirmed"
    @booking.save

    @private_message = PrivateMessage.new(
      conversation_id: @booking.conversation.id,
      body: "#{@booking.book.library.user.email} has accepted your request for #{@booking.book.title}",
      user_id: current_user.id,
      booking_id: @booking.id
    )
    @private_message.save

    redirect_to request.referer.present? ? request.referer : default_path
  end

  def decline
    @booking = Booking.find(params[:id])
    @booking.status = "Declined"
    @booking.save

    @private_message = PrivateMessage.new(
      conversation_id: @booking.conversation.id,
      body: "#{@booking.book.library.user.email} has declined your request for #{@booking.book.title}",
      user_id: current_user.id,
      booking_id: @booking.id
    )
    @private_message.save

    redirect_to request.referer.present? ? request.referer : default_path
  end

  def pending
    @booking = Booking.find(params[:id])
    @booking.status = "Pending"
    @booking.save

    @private_message = PrivateMessage.new(
      conversation_id: @booking.conversation.id,
      body: "#{@booking.user.email} is requesting #{@booking.book.title}",
      user_id: current_user.id,
      booking_id: @booking.id
    )
    @private_message.save

    redirect_to book_booking_path(@booking.book, @booking)
  end

  def show
    @book = Book.find(params[:book_id])
    @booking = Booking.find(params[:id])

    @user = @booking.user

    # conversation

    @messages = Message.where(booking: @booking).sort_by{ |message| message.created_at }

    @conversation = Conversation.find_or_create_by(sender_id: @booking.user.id, recipient_id: @booking.book.library.user.id)
    @booking.conversation = @conversation

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
    @book = Book.find(params[:book_id])
    @user = current_user
    @booking = Booking.new(user: @user)
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.book = Book.find(params[:book_id])
    @booking.user = current_user
    @booking.conversation = Conversation.find_or_create_by(sender_id: @booking.user.id, recipient_id: @booking.book.library.user.id)
    @booking.save

    redirect_to book_booking_path(@booking.book, @booking)
  end

  private

  def booking_params
    params.require(:booking).permit(:checkin_date, :checkout_date, :status, :user_id, :book_id)
  end
end
