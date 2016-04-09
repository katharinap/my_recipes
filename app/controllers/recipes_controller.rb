class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  def index
    @recipes = Recipe.all
  end

  def show
  end

  def edit
  end
  
  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = new_recipe
    
    if @recipe.save
      redirect_to @recipe, notice: 'Recipe was successfully created.'
    else
      @render_final_form = true
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

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.includes(:ingredients, :steps, :references).find(params[:id])
  end

  def new_recipe
    if new_params.empty?
      # after re-display of new, with final form
      Recipe.new(recipe_params)
    else
      Recipe.new.prepare_recipe(new_params)
    end
  end

  def recipe_params
    params.require(:recipe).permit(
      :name,
      :user_id,
      ingredients_attributes: [:id, :value, :_destroy],
      steps_attributes: [:id, :description, :_destroy],
      references_attributes: [:id, :location, :_destroy],
    )
  end

  def new_params
    params.permit(:name, :user_id, :ingredients, :steps)
  end
end
