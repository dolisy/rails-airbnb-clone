class ReviewsController < ApplicationController
  # def index
  #   @reviews = Review.all
  # end

  # def show
  #   @review = Review.find(params[:id])
  #   # @book = Book.find(params[:book_id])
  # end

  def new
    # @booking = Booking.find(params[:booking_id])
    # @book = Book.find(params[:book_id])
    # # @library = Library.find(params[:library_id])

    # @user = current_user
    # @review = Review.new
  end

  def create
    @book = Book.find(params[:book_id])
    @booking = Booking.find(params[:booking_id])
    @review = Review.new(review_params)

    @review.booking = @booking

    if @review.save
      # redirect_to book_booking_path(@book, @booking)
      respond_to do |format|
        format.html { redirect_to book_booking_path(@book, @booking) }
        format.js # will render 'app/views/reviews/create.js'
      end
    else
      # render 'bookings/show'
      respond_to do |format|
        format.html { render 'bookings/show' }
        format.js # will render 'app/views/reviews/create.js'
      end
    end


    # @review = Review.new(review_params)
    # @review.booking = Booking.find(params[:booking_id])
    # # @review.library = Library.find(params[:library_id])
    # @review.user = current_user
    # @review.save

    # redirect_to book_path(@review.booking.book)
    # redirect_to library_review_path(@review.library, @review)
  end

  # def edit
  #   @review = Review.find(params[:id])
  # end

  # def update
  #   @review = Review.find(params[:id])
  #   @review.update(review_params)

  #   if @review.booking.present?
  #     redirect_to booking_review_path(@review.booking, @review)
  #   elsif @review.library.present?
  #     redirect_to library_review_path(@review.library, @review)
  #   end
  # end

  private

  def review_params
    params.require(:review).permit(:content, :stars, :user_id, :booking_id, :library_id)
  end
end
