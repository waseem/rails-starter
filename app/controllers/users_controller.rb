class UsersController < ApplicationController
  skip_before_action :authenticate

  def new
    @user = User.new

    respond_to do |format|
      format.html { render :layout => 'user_sessions' }
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:auth_token] = @user.auth_token

      respond_to do |format|
        format.html { redirect_to root_url }
      end
    else
      respond_to do |format|
        format.html { render action: :new, layout: 'user_sessions' }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
