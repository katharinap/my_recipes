class RecipesControllerTest < ActionController::TestCase
  setup do
    @user = users(:kat)
    sign_in @user
  end

  teardown do
    sign_out @user
  end

  test 'GET index' do
    get :index

    assert_response :success
    assert_template :index
    assert Recipe.count > 0
    assert_equal Recipe.all.to_a, assigns(:recipes)
  end

  test 'GET show' do
    recipe = recipes(:kale_chips)
    get :show, {:id => recipe.to_param}

    assert_equal recipe,  assigns(:recipe)
    assert_template :show
    assert_response :success
  end

  test 'GET new' do
    get :new

    assert_instance_of Recipe, assigns(:recipe)
    assert_template :new
    assert_response :success
  end

  context 'POST create' do
    should "create a  recipe with valid data" do
      assert_difference 'Recipe.count', 1 do
        post :create, { user_id: @user.id,
                        name: "my recipe",
                        ingredients: "Ingredient 1\nIngredient 2\n\n",
                        steps: "Step1 \n Step 2 \n\n",
                        references: "ref 1\n"
        }
        #The below is just cursory testing since the model tests this thoroughly
        recipe = Recipe.last
        assert 2, recipe.ingredients.count
        assert 2, recipe.steps.count
        assert 1, recipe.references.count
      end
      assert_equal "Recipe was successfully created.", flash[:notice]
      assert_redirected_to recipe_path(Recipe.last)
    end

    should "redirect to 'new' with invalid data" do
      assert_no_difference 'Recipe.count' do
        post :create, { user_id: @user.id}
      end
      assert_instance_of Recipe, assigns(:recipe)
      assert assigns(:recipe).new_record?
      assert_template :new
      assert_response :success
    end
  end

  context 'PUT update' do

    setup do
      @original_attrs = {name: "recipe name",
                         user_id: 1,
                         ingredients: "ingredient one\ningredient two",
                         steps: "do something\n\ndo something else",
                         references: "http://www.example.com/1\nhttp://www.example.com/2"}
      @recipe = Recipe.new.prepare_recipe(@original_attrs)
      @recipe.save
    end

    context "with valid data" do
      should 'update name' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({name: "Updated Name"})}
        put :update, update_params
        @recipe.reload
        assert_equal "Updated Name", @recipe.name
        assert_redirected_to recipe_path(@recipe)
      end

      should "update ingredient" do
        ingredient = @recipe.ingredients.first
        update_params =
            {id: @recipe.to_param,
             recipe: @original_attrs.merge(
                  { ingredients_attributes: {ingredient.id.to_s => {id: ingredient.id.to_s,
                                                                    value: "Updated Ingredient"}} })}
        put :update, update_params
        @recipe.reload
        assert_equal "Updated Ingredient", @recipe.ingredients.first.value
        assert_redirected_to recipe_path(@recipe)
      end

      should "update step" do
        step = @recipe.steps.first
        update_params =
            {id: @recipe.to_param,
             recipe: @original_attrs.merge(
                 { steps_attributes: {step.id.to_s => {id: step.id.to_s,
                                                       description: "Updated Step"}} })}
        put :update, update_params
        @recipe.reload
        assert_equal "Updated Step", @recipe.steps.first.description
        assert_redirected_to recipe_path(@recipe)
      end

      should "update references" do
        reference = @recipe.references.first
        update_params =
            {id: @recipe.to_param,
             recipe: @original_attrs.merge(
                 { references_attributes: {reference.id.to_s => {id: reference.id.to_s,
                                                                 location: "Updated Reference"}} })}
        put :update, update_params
        @recipe.reload
        assert_equal "Updated Reference", @recipe.references.first.location
        assert_redirected_to recipe_path(@recipe)
      end

      should 'update picture' do
        #TODO
      end

      should "add ingredient" do
        assert_difference "Ingredient.count", 1 do
          add_ingredient_params =
            {id: @recipe.to_param,
             recipe: @original_attrs.merge(
                    ingredients_attributes: {"7575576587"=>{"value"=>"New Ingredient"}})}
          put :update, add_ingredient_params
        end

        @recipe.reload
        assert_equal "New Ingredient", Ingredient.last.value
        assert_redirected_to recipe_path(@recipe)
      end

      should "add step" do
        assert_difference "Step.count", 1 do
          add_step_params =
              {id: @recipe.to_param,
               recipe: @original_attrs.merge(
                   steps_attributes: {"7575576587"=>{"description"=>"New Step"}})}
          put :update, add_step_params
        end

        @recipe.reload
        assert_equal "New Step", Step.last.description
        assert_redirected_to recipe_path(@recipe)
      end

      should "add references" do
        assert_difference "Reference.count", 1 do
          add_reference_params =
              {id: @recipe.to_param,
               recipe: @original_attrs.merge(
                   references_attributes: {"7575576587"=>{"location"=>"www.newref.com"}})}
          put :update, add_reference_params
        end

        @recipe.reload
        assert_equal "www.newref.com", Reference.last.location
        assert_redirected_to recipe_path(@recipe)
      end

      should "add picture" do
          #TODO
      end

      should "destroy ingredient" do
        ingredient = @recipe.ingredients.first
        assert_difference "Ingredient.count", -1 do
          delete_ingredient_params =
              {id: @recipe.to_param,
               recipe: @original_attrs.merge(
                   ingredients_attributes: {ingredient.id.to_s => {"_destroy"=>"1", "id"=> ingredient.id.to_s }})}
          put :update, delete_ingredient_params
        end
        assert_redirected_to recipe_path(@recipe)
      end

      should "destroy step" do
        step = @recipe.steps.first
        assert_difference "Step.count", -1 do
          delete_step_params =
              {id: @recipe.to_param,
               recipe: @original_attrs.merge(
                   steps_attributes: {step.id.to_s=>{"_destroy"=>"1", id: step.id.to_s}})}
          put :update, delete_step_params
        end
        assert_redirected_to recipe_path(@recipe)
      end

      should "destroy picture" do
        #TODO
      end

      should "destroy references" do
        reference = @recipe.references.first
        assert_difference "Reference.count", -1 do
          delete_reference_params =
              {id: @recipe.to_param,
               recipe: @original_attrs.merge(
                   references_attributes: {reference.id.to_s=>{"_destroy"=>"1", id: reference.id.to_s}})}
          put :update, delete_reference_params
        end
        assert_redirected_to recipe_path(@recipe)
      end
    end

    should "redirect to 'new' with invalid data" do
      assert_no_difference 'Recipe.count' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({name: ""})}
        put :update, update_params
      end

      assert @recipe, assigns(:recipe)
      assert_response :success
      assert_template :edit
    end

  end

  test "DELETE destroy should delete recipe" do
    recipe = recipes(:kale_chips)
    assert_difference 'Recipe.count', -1 do
      delete :destroy, {id: recipe.to_param}
    end
    assert_redirected_to recipes_path
  end
end