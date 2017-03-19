# frozen_string_literal: true
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

class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ratings, dependent: :destroy

  include WithPicture
  has_default_picture_size [400, 400]
  has_thumb_picture_size [50, 50]
  has_mid_picture_size [152, 152]

  acts_as_ordered_taggable

  scope :for_user, ->(user) { where(user_id: user.id) }

  TIME_ATTRIBUTES = %i(prep_time active_time cook_time total_time).freeze

  # FIXME: - uniqueness still OK?
  validates :name, uniqueness: true, presence: true

  scope :by_name, -> { order('name') }
  scope :by_most_recent, -> { order('created_at DESC') }

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

  def ingredient_summary
    IngredientSummary.new(ingredient_list).text
  end

  def notes?
    !notes.blank?
  end

  def time_attributes?
    TIME_ATTRIBUTES.any? { |attr| send(attr) }
  end

  def reference_list
    references.to_s.split("\n").map(&:strip).reject(&:blank?)
  end

  def rating_score(user)
    rating = ratings.find_by(user: user)
    rating ? rating.score : 0
  end

  class << self
    def search(search)
      # FIXME: not very elegant...  we can't only use a joins statement with
      # recipes.name etc. because that ignores recipes without tags
      #
      # this also makes chaining impossible because it returns an
      # array instead of an association
      (search_recipes(search) + search_by_tags(search)).uniq
    end

    def search_recipes(search)
      condition = 'name ILIKE :search OR ingredients ILIKE :search'
      where(condition, search: "%#{search}%")
    end

    def search_by_tags(search)
      joins(:tags).where('tags.name ILIKE :search', search: "%#{search}%")
    end
  end
end
