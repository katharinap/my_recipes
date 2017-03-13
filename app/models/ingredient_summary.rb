# frozen_string_literal: true
# extracts the ingredient part itself from each ingredient entry to
# create a summary string with up to MAX_LENGTH characters.  if there
# are too many ingredients for that, it stops and indicates a longer
# list with ...
class IngredientSummary
  attr_reader :ingredients

  MAX_LENGTH = 150

  def initialize(ingredients)
    @ingredients = ingredients
  end

  def text
    ingredients.reduce('') do |text, ingredient|
      str = content(ingredient)
      break text + ',...' if (text.length + str.length) > MAX_LENGTH
      text = text.blank? ? str : "#{text}, #{str}"
      text
    end
  end

  private

  def content(ingredient)
    val = Ingreedy.parse(ingredient).ingredient
    val.split(',').first
  rescue Ingreedy::ParseFailed
    ingredient
  end
end
