require File.expand_path("../../test_helper", __FILE__)

class RecipesHelperTest < ActionView::TestCase

  setup do
    @recipe = recipes(:kale_chips)
    @user = @recipe.user
    stubs(:current_user).returns(@user)
  end

  context '.allow_edit' do

    should 'return false if not signed_in' do
      stubs(:user_signed_in?).returns(false)
      refute allow_edit?(@recipe)
    end

    context 'signed_in' do
      setup do
        stubs(:user_signed_in?).returns(true)
      end

      should 'not allow editing of recipes of another user' do
        stubs(:current_user).returns(User.new)
        refute allow_edit?(@recipe)
      end

      should 'allow editing of current_user\'s recipe if signed_in' do
        assert allow_edit?(@recipe)
      end
    end
  end

  context '.title' do
    should 'return recipe name' do
      assert_equal title, @recipe.name
    end
  end

  context '.edit_link' do
    should 'return proper markup when allow_edit? == false' do
      stubs(:allow_edit?).returns(false)
      expected_markup =
          "<a disabled=\"disabled\" class=\"disabled\" href=\"#\"><span><i class=\"fa fa-pencil fa-lg\" aria-hidden=\"true\"></i></span></a>"
      assert_equal expected_markup, edit_link(@recipe)
    end

    should 'return proper markup when allow_edit? == true' do
      stubs(:allow_edit?).returns(true)
      instance_variable_set(:@virtual_path, "en")
      expected_markup =
       "<a title=\"Edit\" data-toggle=\"tooltip\" href=\"/recipes/598873390/edit\"><span><i class=\"fa fa-pencil fa-lg\" aria-hidden=\"true\"></i></span></a>"
      assert_equal expected_markup, edit_link(@recipe)
    end
  end

  context '.destroy_link' do
    should 'return proper markup when allow_edit? == false' do
      stubs(:allow_edit?).returns(false)
      expected_markup =
          "<a data-toggle=\"tooltip\" title=\"Nope...\" disabled=\"disabled\" id=\"delete_link\" class=\"disabled\" href=\"#\"><span class=\"right-side-icon\"><i class=\"fa fa-trash fa-lg\" aria-hidden=\"true\"></i></span></a>"
      assert_equal expected_markup, destroy_link(@recipe)
    end

    should 'return proper markup when allow_edit? == true' do
      stubs(:allow_edit?).returns(true)
      instance_variable_set(:@virtual_path, "en")
      expected_markup =
          "<a data-confirm=\"Are you sure?\" data-toggle=\"tooltip\" id=\"delete_link\" title=\"Delete\" rel=\"nofollow\" data-method=\"delete\" href=\"/recipes/#{@recipe.id}\"><span class=\"right-side-icon\"><i class=\"fa fa-trash fa-lg\" aria-hidden=\"true\"></i></span></a>"
      assert_equal expected_markup, destroy_link(@recipe)
    end
  end

  context '.new_link' do
    should 'return the proper markup when user_signed_in? == false' do
      stubs(:user_signed_in?).returns(false)
      expected_markup =
          "<a href=\"/recipes/new\"><button type=\"button\" class=\"btn btn-success-outline btn-sm disabled\" disabled=\"disabled\">Add Recipe</button></a>"
      assert_equal expected_markup, new_link
    end

    should 'return the proper markup when user_signed_in? == true' do
      stubs(:user_signed_in?).returns(true)
      expected_markup =
          "<a href=\"/recipes/new\"><button type=\"button\" class=\"btn btn-success-outline btn-sm\">Add Recipe</button></a>"
      assert_equal expected_markup, new_link
    end
  end

  context '.short_time_attribute_description' do
    should 'return a short description string for the set time attributes of the given recipe' do
      expected_str = 'Active: 5m, Total: 45m'
      assert_equal expected_str, short_time_attribute_description(@recipe)
    end
  end
end
