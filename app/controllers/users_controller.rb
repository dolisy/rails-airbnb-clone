class UsersController < ApplicationController
  def update
    @user = User.find(params[:id])
    @user.update(user_params)

    redirect_to profile_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
