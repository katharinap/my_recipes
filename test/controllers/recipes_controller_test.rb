# == Schema Information
#
# Table name: recipes
#
#  id          :integer          not null, primary key
#  name        :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  picture     :string
#  active_time :integer
#  total_time  :integer
#  prep_time   :integer
#  cook_time   :integer
#  notes       :text
#  directions  :text
#  ingredients :text
#  references  :text
#
# Indexes
#
#  index_recipes_on_active_time  (active_time)
#  index_recipes_on_cook_time    (cook_time)
#  index_recipes_on_prep_time    (prep_time)
#  index_recipes_on_total_time   (total_time)
#  index_recipes_on_user_id      (user_id)
#

class RecipesControllerTest < ActionController::TestCase
  setup do
    @user = create(:user)
    sign_in @user
  end

  teardown do
    sign_out @user
  end

  test 'authentication' do
    sign_out @user
    get :index

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'valid token authentication' do
    sign_out @user
    recipe = create(:kale_chips, user: @user)
    get :show, params: { id: recipe.to_param, user_email: @user.email, user_token: @user.authentication_token, format: 'json' }
    assert_response :success
  end

  test 'invalid token authentication' do
    sign_out @user
    recipe = create(:kale_chips, user: @user)
    get :show, params: { id: recipe.to_param, user_email: @user.email, user_token: 'invalidtoken123', format: 'json' }
    assert_response 401
  end

  test 'valid token for non-json request' do
    sign_out @user
    recipe = create(:kale_chips, user: @user)
    get :show, params: { id: recipe.to_param, user_email: @user.email, user_token: @user.authentication_token }
    assert_response :redirect
   end
  
  test 'GET index' do
    create(:kale_chips, user: @user)
    create(:ice_cream, user: @user)
    get :index

    assert_response :success
    assert_template :index
    assert_equal Recipe.for_user(@user).to_a, assigns(:recipes)
  end

  test 'GET index with search' do
    recipe = create(:kale_chips, user: @user)
    create(:ice_cream, user: @user)
    get :index, params: { search: 'kale' }

    assert_response :success
    assert_template :index
    assert_equal [recipe], assigns(:recipes)
  end

  test 'GET show' do
    recipe = create(:kale_chips, user: @user)
    get :show, params: { id: recipe.to_param}

    assert_equal recipe,  assigns(:recipe)
    assert_template :show
    assert_response :success
  end

  test 'GET show json' do
    recipe = create(:kale_chips, user: @user)
    get :show, params: { id: recipe.to_param, format: :json}

    assert_equal recipe,  assigns(:recipe)
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 'Kale Chips', json['name']
    ingredients = "1 bunch kale\n2 tb olive oil\nseasalt"
    assert_equal ingredients, json['ingredients']
    directions = "Do something with something.\nDo something else with the remaining ingredients."
    assert_equal directions, json['directions']
    puts json.inspect
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
        post :create, params: { recipe:
                          {
                            user_id: @user.id,
                            name: "my recipe",
                            ingredients: "Ingredient 1\nIngredient 2\n\n",
                            directions: "Step1 \n Step 2 \n\n",
                            tag_list: 'veggie, snack, healthy',
                            references: "ref 1\n",
                            active_time: 20,
                            prep_time: 15,
                            cook_time: 45,
                            total_time: 60,
                            notes: "If you can't get ingredient 2, you can use ingredient 3 instead"
                          }
                      }
        #The below is just cursory testing since the model tests this thoroughly
        recipe = Recipe.last
        refute_nil recipe.ingredients
        refute_nil recipe.directions
        refute_nil recipe.references
        assert 3, recipe.tags.count
        assert_equal 20, recipe.active_time
        assert_equal 15, recipe.prep_time
        assert_equal 45, recipe.cook_time
        assert_equal 60, recipe.total_time
        assert "veggie, snack, healthy", recipe.tag_list
        refute_nil recipe.notes
      end
      assert_equal "Recipe was successfully created.", flash[:notice]
      assert_redirected_to recipe_path(Recipe.last)
    end

    should "redirect to 'new' with invalid data" do
      assert_no_difference 'Recipe.count' do
        post :create, params: { user_id: @user.id, recipe: { ingredients: 'some ingredient' }}
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
                         user_id: @user.id,
                         ingredients: "ingredient one\ningredient two",
                         directions: "do something\n\ndo something else",
                         references: "http://www.example.com/1\nhttp://www.example.com/2",
                         tag_list: "tag_1, tag_2",
                         active_time: 10,
                         prep_time: 5,
                         cook_time: 40,
                         total_time: 45,
                         notes: "Some notes"}
      @recipe = Recipe.create(@original_attrs)
      @recipe.save
    end

    context "with valid data" do
      should 'update name' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({name: "Updated Name"})}
        put :update, params: update_params
        @recipe.reload
        assert_equal "Updated Name", @recipe.name
        assert_redirected_to recipe_path(@recipe)
      end

      should 'update tag_list' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({tag_list: "Updated Tag"})}
        put :update, params: update_params
        @recipe.reload
        assert_equal ["updated tag"], @recipe.tag_list #ActsAsTaggableOn.force_lowercase is set to 'true'
        assert_redirected_to recipe_path(@recipe)
      end

      should "update ingredient" do
        new_ingredients = @recipe.ingredients + "\n2 tb soy sauce\n"
        update_params =
            {id: @recipe.to_param,
             recipe: @original_attrs.merge(
                  { ingredients: new_ingredients })}
        put :update, params: update_params
        @recipe.reload
        assert_equal new_ingredients, @recipe.ingredients
        assert_redirected_to recipe_path(@recipe)
      end

      should "update directions" do
        new_directions = "Do something different\nAnd then something else different"
        update_params =
            {id: @recipe.to_param,
             recipe: @original_attrs.merge({ directions: new_directions })}
        put :update, params: update_params
        @recipe.reload
        assert_equal new_directions, @recipe.directions
        assert_redirected_to recipe_path(@recipe)
      end

      should "update references" do
        new_reference = 'Best Cookbook ever, page 42'
        update_params =
            {id: @recipe.to_param,
             recipe: @original_attrs.merge(
                 { references: new_reference })}
        put :update, params: update_params
        @recipe.reload
        assert_equal new_reference, @recipe.references
        assert_redirected_to recipe_path(@recipe)
      end

      should 'update active time' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({active_time: 15})}
        put :update, params: update_params
        @recipe.reload
        assert_equal 15, @recipe.active_time
        assert_redirected_to recipe_path(@recipe)
      end

      should 'unset active time if field is left blank' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({active_time: ''})}
        put :update, params: update_params
        @recipe.reload
        assert_nil @recipe.active_time
        assert_redirected_to recipe_path(@recipe)
      end

      should 'update prep time' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({prep_time: 10})}
        put :update, params: update_params
        @recipe.reload
        assert_equal 10, @recipe.prep_time
        assert_redirected_to recipe_path(@recipe)
      end

      should 'update cook time' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({cook_time: 60})}
        put :update, params: update_params
        @recipe.reload
        assert_equal 60, @recipe.cook_time
        assert_redirected_to recipe_path(@recipe)
      end

      should 'update total time' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({total_time: 60})}
        put :update, params: update_params
        @recipe.reload
        assert_equal 60, @recipe.total_time
        assert_redirected_to recipe_path(@recipe)
      end

      should 'update notes' do
        update_params = {id: @recipe.to_param, recipe:
            @original_attrs.merge({notes: 'Updated notes'})}
        put :update, params: update_params
        @recipe.reload
        assert_equal 'Updated notes', @recipe.notes
        assert_redirected_to recipe_path(@recipe)
      end

      should 'update picture' do
        #TODO
      end

      should "add picture" do
          #TODO
      end

      should "destroy picture" do
        #TODO
      end
    end

    should "redirect to 'new' with invalid data" do
      assert_no_difference 'Recipe.count' do
        update_params = { id: @recipe.to_param,
                         recipe: @original_attrs.merge({name: ""}),
                         user_id: @user.id }
        put :update, params: update_params
      end

      assert @recipe, assigns(:recipe)
      assert_response :success
      assert_template :edit
    end

    should "not allow editing of another user's recipe" do
      assert_no_difference 'Recipe.count' do
        update_params = { id: @recipe.to_param,
                         recipe: @original_attrs,
                         user_id: @user.id + 1 }
        put :update, params: update_params
        assert_response 302
      end
    end
  end

  test "DELETE destroy should delete recipe" do
    recipe = create(:kale_chips, user: @user)
    assert_difference 'Recipe.count', -1 do
      delete :destroy, params: { id: recipe.to_param }
    end
    assert_redirected_to recipes_path
  end
end
