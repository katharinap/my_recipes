module RecipesHelper
  def title
    @recipe.try :name
  end
  
  def allow_edit?(recipe)
    return false unless user_signed_in?
    recipe.user_id == current_user.id
  end
end
