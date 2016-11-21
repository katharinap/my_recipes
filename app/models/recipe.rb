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

class Recipe < ActiveRecord::Base
  belongs_to :user

  include WithPicture
  has_default_picture_size [400, 400]
  has_thumb_picture_size [50, 50]

  acts_as_ordered_taggable

  scope :for_user, ->(user) { where(user_id: user.id) }

  TIME_ATTRIBUTES = %i(prep_time active_time cook_time total_time)
  
  # FIXME - uniqueness still OK?
  validates :name, uniqueness: true, presence: true

  scope :by_name, -> { order("name") }
  scope :by_most_recent, -> { order("created_at DESC") }

  def user_name
    return 'unknown' unless user
    user.name || user.email
  end

  def steps
    directions.to_s.split("\n").map(&:strip).reject(&:blank?)
  end
  
  def ingredient_list
    ingredients.to_s.split("\n").map(&:strip).reject(&:blank?)
  end
  
  def reference_list
    references.to_s.split("\n").map(&:strip).reject(&:blank?)
  end
end
