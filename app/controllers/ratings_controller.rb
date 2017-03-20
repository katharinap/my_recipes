# frozen_string_literal: true
class RatingsController < ApplicationController
  before_action :set_rating, only: %i(update)
  before_action :authorize_user, only: %i(update)

  def update
    @rating.update(rating_params)
    head :ok
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def authorize_user
    head :forbidden if @rating.user != current_user
  end

  def rating_params
    params.require(:rating).permit(:score)
  end
end
