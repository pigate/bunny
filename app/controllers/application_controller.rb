class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Exceptions::AuthenticationError, with: :not_signed_in
  rescue_from Exceptions::NotAuthorizedError, with: :not_authorized

  private
    def not_signed_in
     #render :text => "What are you trying to do? Sign in!", status: :not_found
     redirect_to members_login_path, status: 403
     
    end
    def not_authorized
      render plain: "404 Not Authorized", status: 404
    end
end
