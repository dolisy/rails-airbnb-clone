class LibrariesController < ApplicationController
  def show
    @library = Library.find(params[:id])
  end

  def new
    @user = current_user
    @library = Library.new(user: current_user)
  end

  def create
    @library = Library.new(library_params)
    @library.user = current_user
    @library.save

    redirect_to library_path(@library)
  end

  private

  def library_params
    params.require(:library).permit(:name, :user_id)
  end
end
