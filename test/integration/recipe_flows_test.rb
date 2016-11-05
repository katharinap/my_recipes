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
    assert page.has_content?("All My Recipes"), "Should show the list of all recipes"
  end

  def do_create_recipe
    # click_button('Add Recipe') #TODO Why is this an issue?
    visit "/recipes/new"
    assert page.has_content?("New Recipe"), "Should be on 'New Recipe' page"
    fill_in "name", with: "My Recipe"
    fill_in "ingredients", with: "Ingredient 1\n Ingredient 2"
    fill_in "steps", with: "Step 1\n Step 2"
    fill_in "references", with: "www.myrecipe.com"
    fill_in "tag_list", with: "veggie, snack, vegan"
    fill_in "active_time", with: 15
    fill_in "total_time", with: 90
    fill_in "notes", with: 'Be careful with something'

    click_button('Submit')

    assert page.has_content? "Recipe was successfully created."
    assert page.has_content? "My Recipe"
    assert page.has_content? "Step 1"
    assert page.has_content? "Step 2"
    assert page.has_content? "Ingredient 1"
    assert page.has_content? "Ingredient 2"
    assert page.has_content? "www.myrecipe.com"
    assert page.has_content? "veggie, snack, vegan"
    assert page.has_content? "Active time"
    assert page.has_content? "15 minutes"
    assert page.has_content? "Total time"
    assert page.has_content? "1 hour 30 minutes"
    assert page.has_content? @user.email
    assert page.has_content? 'Be careful with something'
  end

  # TODO: test references
  def do_edit_recipe
    recipe = Recipe.last
    visit "/recipes/#{recipe.id}/edit"
    assert page.has_content?("Edit Recipe"), "Should be on 'Edit Recipe' page"
    assert page.has_content?("Picture")

    fill_in "recipe[name]", with: "new_#{recipe.name}"
    fill_in "recipe[active_time]", with: ''
    fill_in "recipe[prep_time]", with: 10
    fill_in "recipe[cook_time]", with: 120
    fill_in "recipe[total_time]", with: 130
    fill_in "recipe[notes]", with: 'Make sure to do something before something else'
    click_button "Update"

    assert page.has_content? "Recipe was successfully updated."
    assert page.has_content? recipe.steps.first.description
    assert page.has_content? recipe.ingredients.first.value
    assert page.has_content? @user.email #This should be recipe.user.email. FIXME issue 36
    assert page.has_no_content? "Active time"
    assert page.has_content? "Prep time"
    assert page.has_content? "10 minutes"
    assert page.has_content? "Cook time"
    assert page.has_content? "2 hours"
    assert page.has_content? "Total time"
    assert page.has_content? "2 hours 10 minutes"
    assert page.has_content? 'Make sure to do something before something else'
  end

  def do_destroy_recipe
    recipe = Recipe.create(name: "recipe #{rand(800000)}",
                           ingredients: [Ingredient.new(value: "This is an ingredient")],
                           steps: [Step.new(description: "This is a step")],
                           user: @user)

    visit "/recipes/#{recipe.id}"

    confirm_with(:ok) do
      find_by_id('delete_link').click
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
