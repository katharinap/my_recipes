# frozen_string_literal: true
# == Schema Information
#
# Table name: recipes
#
#  id          :integer          not null, primary key
#  name        :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  picture     :string
#  active_time :integer
#  total_time  :integer
#  prep_time   :integer
#  cook_time   :integer
#  notes       :text
#  directions  :text
#  ingredients :text
#  references  :text
#
# Indexes
#
#  index_recipes_on_active_time  (active_time)
#  index_recipes_on_cook_time    (cook_time)
#  index_recipes_on_prep_time    (prep_time)
#  index_recipes_on_total_time   (total_time)
#  index_recipes_on_user_id      (user_id)
#

class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_rating, only: %i(show)
  before_action :set_ratings, only: %i(index)
  before_action :authenticate_user!
  before_action :authorize_user, only: [:edit, :update, :destroy]

  PDF_OPTS = { layout: 'pdf', encoding: 'UTF-8' }.freeze

  def index
    @recipes = Recipe.for_user(current_user).includes(:user, :tags)
    @recipes = @recipes.search(params[:search]) if params[:search]
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render({ pdf: 'my_recipe',
                 template: 'recipes/show.html.haml' }.merge(PDF_OPTS))
      end
      format.json do
        render json: @recipe
      end
    end
  end

  def edit; end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: 'Recipe was successfully created.'
    else
      render :new
    end
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: 'Recipe was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_url, notice: 'Recipe was successfully destroyed.'
  end

  private

  def authorize_user
    head :forbidden if @recipe.user != current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_rating
    @rating = Rating.find_or_create_by(recipe: @recipe, user: current_user)
  end

  def set_ratings
    @ratings = Hash[
      Rating.where(user: current_user).map do |rating|
        [rating.recipe_id, rating]
      end
    ]
  end

  # rubocop:disable Metrics/MethodLength
  def recipe_params
    params.require(:recipe).permit(
      :name,
      :user_id,
      :directions,
      :picture,
      :remove_picture,
      :picture_cache,
      :tag_list,
      :prep_time,
      :active_time,
      :cook_time,
      :total_time,
      :notes,
      :ingredients,
      :references
    )
  end
  # rubocop:enable Metrics/MethodLength
end
