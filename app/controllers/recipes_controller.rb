class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @recipes = Recipe.for_user(current_user)
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

  def authorize_user
    render nothing: true, status: :forbidden if (@recipe.user != current_user)
  end

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
      :picture,
      :remove_picture,
      :picture_cache,
      :tag_list,
      :prep_time,
      :active_time,
      :cook_time,
      :total_time,
      ingredients_attributes: [:id, :value, :_destroy],
      steps_attributes: [:id, :description, :picture, :remove_picture, :picture_cache, :_destroy],
      references_attributes: [:id, :location, :_destroy]
    )
  end

  def new_params
    params.permit(:name, :user_id, :ingredients, :steps, :references, :tag_list, :prep_time, :active_time, :cook_time, :total_time)
  end
end
