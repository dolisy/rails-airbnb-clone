class ReviewsController < ApplicationController
  # def index
  #   @reviews = Review.all
  # end

  # def show
  #   @review = Review.find(params[:id])
  #   # @book = Book.find(params[:book_id])
  # end

  def new
    @booking = Booking.find(params[:booking_id])
    @library = Library.find(params[:library_id])
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.booking = Booking.find(params[:booking_id])
    @review.library = Library.find(params[:booking_id])
    @review.save

    if @review.booking.present?
      redirect_to booking_review_path(@review.booking, @review)
    elsif @review.library.present?
      redirect_to library_review_path(@review.library, @review)
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    @review.update(review_params)

    if @review.booking.present?
      redirect_to booking_review_path(@review.booking, @review)
    elsif @review.library.present?
      redirect_to library_review_path(@review.library, @review)
    end
  end

  def review_params
    params.require(:review).permit(:content, :stars, :booking_id, :library_id)
  end
end
