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

    click_button('Submit')

    assert page.has_content? "Recipe was successfully created."
    assert page.has_content? "My Recipe"
    assert page.has_content? "Step 1"
    assert page.has_content? "Ingredient 1"
    assert page.has_content? @user.email
  end

  def do_edit_recipe
    recipe = Recipe.last
    visit "/recipes/#{recipe.id}/edit"
    assert page.has_content?("Edit Recipe"), "Should be on 'Edit Recipe' page"
    assert page.has_content?("Picture")

    fill_in "recipe[name]", with: "new_#{recipe.name}"
    click_button "Update"

    assert page.has_content? "Recipe was successfully updated."
    assert page.has_content? recipe.steps.first.description
    assert page.has_content? recipe.ingredients.first.value
    assert page.has_content? @user.email #This should be recipe.user.email. FIXME issue 36
  end

  def do_destroy_recipe
    recipe = Recipe.create(name: "recipe #{rand(800000)}",
                           ingredients: [Ingredient.new(value: "This is an ingredient")],
                           steps: [Step.new(description: "This is a step")],
                           user: @user)

    visit "/recipes/#{recipe.id}"
 #   puts "#{page.html.inspect}"

    confirm_with(:ok) do
      find_by_id('delete_link').click
    end

  end

  test "login and CRUD recipe" do
    do_login
    do_create_recipe
    do_edit_recipe
   # do_destroy_recipe TODO
  end
end