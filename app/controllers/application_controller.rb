class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate
  helper_method :current_user, :signed_in?

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(session[:auth_token]) if session[:auth_token]
  end

  def signed_in?
    current_user.present?
  end

  def authenticate
    unless signed_in?
      respond_to do |format|
        format.html { redirect_to sign_in_path, alert: "Please sign in to continue." }
      end
    end
  end
end
