require File.expand_path("../../test_helper", __FILE__)

class IngredientSummaryTest < ActiveSupport::TestCase
  context '.text' do
    should 'strip the amounts from the ingredients' do
      ingredients = ['1 cup quinoa', '1/3 cup tahini sauce', '1 cup kale', '1 tbsp olive oil']
      expected_result = 'quinoa, tahini sauce, kale, olive oil'
      assert_equal expected_result, IngredientSummary.new(ingredients).text
    end

    should 'abbreviate the text if it would otherwise exceed 150 characters' do
      ingredients = [
        '2 tablespoons refined coconut oil, divided',
        '12 oz Brussel sprouts, trimmed and quartered',
        '1 large carrot, peeled and sliced into thin half-moons',
        '1/4 cup pine nuts',
        '1/4 cup fresh basil',
        '1 cup loosely packed fresh cilantro',
        '1 cup finely chopped scallions',
        '2 cloves garlic, minced',
        '1 tablespoon fresh minced ginger',
        '4 cups cooked and cooled jasmine rice [see note]',
        '1/4 teaspoon red pepper flakes',
        '2 tablespoons soy sauce or tamari',
        '1 tablespoon fresh lime juice',
        '1/2 teaspoon agave'
      ]
      expected_result = 'refined coconut oil, Brussel sprouts, large carrot, pine nuts, fresh basil, loosely packed fresh cilantro, finely chopped scallions, garlic,...'
      assert_equal expected_result, IngredientSummary.new(ingredients).text
    end
  end
end
