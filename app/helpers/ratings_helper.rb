# frozen_string_literal: true
module RatingsHelper
  def recipe_score(recipe, ratings_hsh)
    ratings_hsh[recipe.id].try(:score) || 0
  end
end
