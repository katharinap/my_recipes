# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

  user = User.where(email: 'seed_user@recipe.com').first_or_create do |new_user|
    new_user.email = 'seed_user@recipe.com'
    new_user.password = 'testing123'
    new_user.name = 'Seeded User'
  end

  recipe = Recipe.where(name: "seeded recipe").first_or_create do |new_recipe|
    new_recipe.name = "seeded recipe"
    new_recipe.user = user
    new_recipe.picture = "some_picture.jpg"
    new_recipe.tag_list = "seed_tag_1, seed_tag_2"
  end


  Ingredient.where(value: "Seeded Ingredient").first_or_create do |new_ingredient|
    new_ingredient.recipe = recipe
    new_ingredient.value = "Seeded Ingredient"
  end

  Step.where(description: "Seeded Step").first_or_create do |new_step|
    new_step.recipe = recipe
    new_step.description = "Seeded Step"
    new_step.idx = 1
    new_step.picture = "some_step.jpg"
 end

  Reference.where(location: "www.seed_reference.com").first_or_create do |new_reference|
    new_reference.recipe = recipe
    new_reference.location = "www.seed_reference.com"
  end

