class ApplicationController < ActionController::Base
  protect_from_forgery
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_filter :authenticate_user!
end
