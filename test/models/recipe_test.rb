# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  picture    :string
#  user_id    :integer
#
require File.expand_path("../../test_helper", __FILE__)

class RecipeTest < ActiveSupport::TestCase

  should belong_to :user

  context 'validations' do
    should validate_presence_of :name
    should validate_uniqueness_of :name
    should have_many :ingredients
    should have_many :steps
    should have_many :references

    should "be valid" do
      assert recipes(:kale_chips).valid?
    end
  end

  context '.user_name' do
    setup do
      @user = User.new(name: 'test_name', email: 'test@email.com')
      @recipe = Recipe.new(user: @user)
    end

    should "return 'unknown' if there is no user" do
      recipe = Recipe.new
      assert_equal 'unknown', recipe.user_name, "user_name should be 'unknown' if there is no user"
    end

    should "return user's name" do
      assert_equal @user.name, @recipe.user_name, "user_name should be user's name"
    end

    should "return user's email if there is no name" do
      @recipe.user.name = nil
      assert_equal @user.email, @recipe.user_name, "user_name should be user's email"
    end
  end

  context '.prepare_recipe ' do
    setup do
     @params = {
         name: "\t a new recipe\r\n ",
         user_id: 1,
         ingredients: "Kale\nSalt\t\nPepper",
         tag_list: "Kale, Snack, Healthy",
         steps: "Sprinkle salt and pepper\nDrizzle oil\t\nBake in oven at 450c ",
         references: "www.goodfood.com\n\n www.foodforcause.in"
     }
     @recipe = Recipe.new.prepare_recipe(@params)
    end

    should "set name" do
      assert_equal "a new recipe", @recipe.name
    end

    should "set user" do
      assert_equal @params[:user_id], @recipe.user_id
    end

    should "set tags" do
      assert_equal %w(kale snack healthy), @recipe.tag_list, "tag_list is incorrect"
    end

    should "build_dependents" do
      assert_equal %w(Kale Salt Pepper), @recipe.ingredients.map(&:value)
      assert_equal ['Sprinkle salt and pepper', 'Drizzle oil', 'Bake in oven at 450c'], @recipe.steps.map(&:description)
      assert_equal %w(www.goodfood.com www.foodforcause.in), @recipe.references.map(&:location)
    end
  end

  context 'by name scope' do
    setup do
      @user = User.new(name: 'test_name', email: 'test@email.com')
    end

    should "sort by name" do
      recipes = Recipe.by_name
      assert_equal 2, recipes.count
      assert_equal [recipes(:ice_cream).name, recipes(:kale_chips).name], recipes.collect(&:name)
    end
  end
end

