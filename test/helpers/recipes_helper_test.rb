require File.expand_path("../../test_helper", __FILE__)

class RecipesHelperTest < ActionView::TestCase

  context '.allow_edit' do
    setup do
      @recipe = recipes(:kale_chips)
      @user = @recipe.user
      stubs(:current_user).returns(@user)
    end

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
end