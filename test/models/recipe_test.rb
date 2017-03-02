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
#

require File.expand_path("../../test_helper", __FILE__)

class RecipeTest < ActiveSupport::TestCase

  should belong_to :user

  context 'validations' do
    should validate_presence_of :name
    should validate_uniqueness_of :name

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

  context '.steps' do
    setup do
      @recipe = Recipe.new(directions: "Sprinkle salt and pepper\n\tDrizzle oil\n\n Bake in oven at 450c ")
    end

    should "return an array of single steps without leading or trailing whitespace" do
      assert_equal ['Sprinkle salt and pepper', 'Drizzle oil', 'Bake in oven at 450c'], @recipe.steps
    end
  end
end

