class LibrariesController < ApplicationController
    skip_before_action :authenticate_user!, only: :show

  def show
    @library = Library.find(params[:id])
    @lib_coordinates = { lat: @library.latitude, lng: @library.longitude }
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

  def edit
    @library = Library.find(params[:id])
  end

  def update
    @library = Library.find(params[:id])
    @library.update(library_params)

    redirect_to library_path(@library)
  end

  def destroy
    @library = Library.find(params[:id])
    @library.destroy

    redirect_to home_path
  end


  private

  def library_params
    params.require(:library).permit(:name, :address, :user_id)
  end
end
