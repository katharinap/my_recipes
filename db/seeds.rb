# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

  user = User.find_by_email('seed_user@recipe.com') || User.create(email: 'seed_user@recipe.com',
                                                                  password: 'testing123',
                                                                  name: 'Seeded User')

  recipe = Recipe.find_by_name("seeded recipe") || Recipe.create(name: "seeded recipe",
                                                                 user: user,
                                                                 picture: "some_picture.jpg")


  Ingredient.find_by_value("Seeded Ingredient") || Ingredient.create(recipe: recipe,
                                                                     value: "Seeded Ingredient")

  Step.find_by_description("Seeded Step") || Step.create(recipe: recipe,
                                                          description: "Seeded Step",
                                                          idx: 1,
                                                          picture: "some_step.jpg")
  Reference.find_by_location("www.seed_reference.com") || Reference.create( recipe: recipe,
                                                                            location: "www.seed_reference.com")