class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_logged_in?


  protected

  def current_user
    session["current_user"] || {}
  end

  def user_logged_in?
    session["current_user"].blank? ? false : true
  end
end
