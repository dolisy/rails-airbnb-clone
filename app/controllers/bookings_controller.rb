class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def confirm
    @booking = Booking.find(params[:id])
    @booking.status = "confirmed"
    @booking.save
    redirect_to messages_path
  end

  def decline
    @booking = Booking.find(params[:id])
    @booking.status = "declined"
    @booking.save
    redirect_to messages_path
  end

  def show
    @book = Book.find(params[:book_id])
    @booking = Booking.find(params[:id])
    # @book = Book.find(params[:book_id])

    # for reviews-ajax
    @user = current_user
    @review = Review.new(user: current_user)

    if @booking.status == "pending"
      @message = Message.new(
        subject: "You have a new book request for #{@booking.book.title}",
        content: "Please confirm the request",
        booking_id: @booking.id
      )
      @message.save
    end
  end

  def new
    @book = Book.find(params[:book_id])
    @user = current_user
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.book = Book.find(params[:book_id])
    @booking.user = current_user
    @booking.save

    redirect_to book_booking_path(@booking.book, @booking)
  end

  def booking_params
    params.require(:booking).permit(:checkin_date, :checkout_date, :status, :user_id, :book_id)
  end
end
