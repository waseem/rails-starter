class PasswordResetsController < ApplicationController
  layout 'user_sessions'
  skip_before_action :authenticate

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    if user.present?
      user.send_password_reset_email
    end

    flash[:notice] = "We have sent a password reset email to that email address."

    respond_to do |format|
      format.html { redirect_to new_password_reset_url }
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])

    if params[:user][:password].blank? || params[:user][:password_confirmation].blank?
      respond_to do |format|
        format.html { redirect_to edit_password_reset_url(@user.password_reset_token), alert: "Can not accept blank password" }
      end

    elsif @user.update_attributes(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      @user.update_attribute(:password_reset_token, nil)

      respond_to do |format|
        format.html { redirect_to root_url, notice: "Password has been reset!" }
      end

    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end
end
