# frozen_string_literal: true
# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  recipe_id  :integer
#  user_id    :integer
#  score      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ratings_on_recipe_id  (recipe_id)
#  index_ratings_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_9c2c9f4540  (recipe_id => recipes.id)
#  fk_rails_a7dfeb9f5f  (user_id => users.id)
#

class Rating < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user
end
