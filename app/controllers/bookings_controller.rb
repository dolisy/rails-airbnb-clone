class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def show
    @book = Book.find(params[:book_id])
    @booking = Booking.find(params[:id])
    # @book = Book.find(params[:book_id])

    # for reviews-ajax
    @user = current_user
    @review = Review.new(user: current_user)
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
    params.require(:booking).permit(:checkin_date, :checkout_date, :user_id, :book_id)
  end
end
