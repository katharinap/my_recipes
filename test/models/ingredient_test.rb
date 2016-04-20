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

  test 'is valid' do
    assert ingredients(:kale).valid?
  end

  test 'value is required' do
    assert ingredients(:ingredient_without_value).invalid?, "'Value' is required"
  end
end
