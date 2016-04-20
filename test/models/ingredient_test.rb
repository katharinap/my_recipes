# == Schema Information
#
# Table name: ingredients
#
#  id         :integer          not null, primary key
#  recipe_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  value      :string
#
require 'test_helper'

class IngredientTest < ActiveSupport::TestCase

  should belong_to :recipe

  context 'validations' do
    should validate_presence_of :value

    should "be valid" do
      assert ingredients(:kale).valid?, "Ingredient should be valid"
    end
  end
end