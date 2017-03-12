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

FactoryGirl.define do
  factory :recipe do
    name 'myString'
  end
  
  factory :kale_chips, class: Recipe do
    name 'Kale Chips'
    ingredients "1 bunch kale\n2 tb olive oil\nseasalt"
    directions "Do something with something.\nDo something else with the remaining ingredients."
    references 'http://www.foodnetwork.com/recipes/melissa-darabian/crispy-kale-chips-recipe.html'
    picture 'a_picture.jpg'
    active_time 5
    total_time 45
    user
  end

  factory :ice_cream, class: Recipe do
    name 'Ice Cream'
    directions 'Put everything into a blender and then freeze it.'
    user
    picture 'ice_cream.jpg'
    notes 'Keep it cold'
  end
end
