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
#

class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_user, only: [:edit, :update, :destroy]

  PDF_OPTS = { layout: 'pdf', encoding: 'UTF-8' }.freeze

  def index
    @recipes = Recipe.for_user(current_user)
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
    render nothing: true, status: :forbidden if @recipe.user != current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
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
