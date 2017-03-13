# frozen_string_literal: true
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  acts_as_token_authentication_handler_for User, if: :format_json?
  # https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts
  layout :layout_by_resource

  def format_json?
    request.format.json?
  end

  private

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
