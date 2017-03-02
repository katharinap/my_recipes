# frozen_string_literal: true
class AuthenticationTokensController < ApplicationController
  before_action :authenticate_user!

  def update
    current_user.reset_authentication_token!
    redirect_to(:back)
  end
end
