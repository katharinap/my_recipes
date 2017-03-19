class RecipeFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: "int_test@email.com", password: "testing123")
  end

  def do_login
    visit "/users/sign_in"

    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button('Log in')

    assert_equal "/", current_path
    assert page.has_content?("Signed in successfully."), "Should display 'Signed In Successfully' message"
  end

  def do_create_recipe
    # click_button('Add Recipe') #TODO Why is this an issue?
    visit "/recipes/new"
    assert page.has_content?("New Recipe"), "Should be on 'New Recipe' page"
    fill_in "recipe[name]", with: "My Recipe"
    fill_in "recipe[ingredients]", with: "Ingredient 1\n Ingredient 2"
    fill_in "recipe[directions]", with: "Step 1\n Step 2"
    fill_in "recipe[references]", with: "www.myrecipe.com"
    fill_in "recipe[tag_list]", with: "veggie, snack, vegan"
    fill_in "recipe[active_time]", with: 15
    fill_in "recipe[total_time]", with: 90
    fill_in "recipe[notes]", with: 'Be careful with something'

    click_button('Update')

    assert page.has_content? "Recipe was successfully created."
    assert page.has_content? "My Recipe"
    assert page.has_content? "Step 1"
    assert page.has_content? "Step 2"
    assert page.has_content? "Ingredient 1"
    assert page.has_content? "Ingredient 2"
    assert page.has_content? "www.myrecipe.com"
    assert page.has_content? "snack, vegan, veggie"
    assert page.has_content? "Active"
    assert page.has_content? "15 minutes"
    assert page.has_content? "Total"
    assert page.has_content? "1 hour 30 minutes"
    assert page.has_content? 'Be careful with something'
  end

  # TODO: test references
  def do_edit_recipe
    recipe = Recipe.last
    visit "/recipes/#{recipe.id}/edit"
    assert page.has_content?("Picture")

    assert_equal 'My Recipe', find_field('recipe_name').value
    assert_equal "Ingredient 1\n Ingredient 2", find_field('recipe_ingredients').value
    assert_equal "Step 1\n Step 2", find_field('recipe_directions').value
    assert_equal 'www.myrecipe.com', find_field('recipe_references').value
    assert_equal 'snack, vegan, veggie', find_field('recipe_tag_list').value
    assert_equal '15', find_field('recipe_active_time').value
    assert_equal '90', find_field('recipe_total_time').value
    assert_equal 'Be careful with something', find_field('recipe_notes').value

    fill_in "recipe[name]", with: "new_#{recipe.name}"
    fill_in "recipe[active_time]", with: ''
    fill_in "recipe[prep_time]", with: 10
    fill_in "recipe[cook_time]", with: 120
    fill_in "recipe[total_time]", with: 130
    fill_in "recipe[notes]", with: 'Make sure to do something before something else'
    click_button "Update"

    assert page.has_content? "Recipe was successfully updated."
    assert page.has_content? recipe.directions
    assert page.has_content? recipe.ingredients
    assert page.has_content? recipe.references
    assert page.has_no_content? "Active"
    assert page.has_content? "Prep"
    assert page.has_content? "10 minutes"
    assert page.has_content? "Cook"
    assert page.has_content? "2 hours"
    assert page.has_content? "Total"
    assert page.has_content? "2 hours 10 minutes"
    assert page.has_content? 'Make sure to do something before something else'
  end

  def do_rate_recipe
    recipe = Recipe.last
    visit "/recipes/#{recipe.id}/edit"
    assert_equal 0, recipe.rating.score
    page.execute_script %Q{ $('#rating').raty('click', 2); }
    recipe = Recipe.last
    assert_equal 2, recipe.rating.score
  end
  
  def do_destroy_recipe
    recipe = Recipe.create(name: "recipe #{rand(800000)}",
                           ingredients: "This is an ingredient",
                           directions: "This is a step",
                           user: @user)

    visit "/recipes/#{recipe.id}"

    confirm_with(:ok) do
      find_by_id('delete_link').trigger('click')
    end

    assert page.has_content? "Recipe was successfully destroyed."
  end

  test "login and CRUD recipe" do

    require_javascript_driver!
    do_login
    do_create_recipe
    do_edit_recipe
    do_destroy_recipe
  end
end
