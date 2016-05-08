class ConfirmationsController < ApplicationController
  layout 'user_sessions'
  skip_before_action :authenticate

  def new
    user = User.find_by_confirmation_token(params[:confirmation_token])

    if user.present? && !user.confirmed?
      user.confirm
      session[:auth_token] = user.auth_token
      flash[:notice] = "You have successfully confirmed your email."

    else
      flash[:alert] = "We do not have record of this email."
    end

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end
end
