class UserSessionsController < ApplicationController
  skip_before_action :authenticate
  layout 'user_sessions'

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:auth_token] = user.auth_token
      respond_to do |format|
        format.html { redirect_to root_url }
      end

    else
      flash.now.alert = "Invalid email or password."

      respond_to do |format|
        format.html { render action: :new }
      end
    end
  end

  def destroy
    reset_session

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end
end
