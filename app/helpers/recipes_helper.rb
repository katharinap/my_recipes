module RecipesHelper
  def title
    @recipe.try :name
  end
end
