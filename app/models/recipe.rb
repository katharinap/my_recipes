# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  picture    :string
#

class Recipe < ActiveRecord::Base
  belongs_to :user

  include WithPicture
  has_default_picture_size [400, 400]
  has_thumb_picture_size [50, 50]

  acts_as_ordered_taggable

  DEPENDENT_ATTRIBUTES = {
    ingredients: :value,
    steps: :description,
    references: :location,
  }

  # FIXME - uniqueness still OK?
  validates :name, uniqueness: true, presence: true

  scope :by_name, -> { order("name") }
  scope :by_most_recent, -> { order("created_at DESC") }

  DEPENDENT_ATTRIBUTES.each do |dependent, attr|
    has_many dependent, dependent: :destroy
    accepts_nested_attributes_for dependent,
                                  allow_destroy: true,
                                  reject_if: -> (params) { params[attr].blank? }
  end

  def user_name
    return 'unknown' unless user
    user.name || user.email
  end

  #FIXME: Should this be a static method?
  def prepare_recipe(params)
    self.name = params[:name].try(:strip)
    self.user_id = params[:user_id]
    self.tag_list = params[:tag_list]
    build_dependents(params)

    self
  end

  # builds ingredients, steps and references if specified in params
  # hash
  def build_dependents(params)
    DEPENDENT_ATTRIBUTES.each do |dependent, attr|
      next if params[dependent].blank?
      params[dependent].split("\n").map(&:strip).each do |str|
        next if str.blank?
        # e.g. ingredients.build(value: 'something ingredient')
        (send dependent).build(attr => str)
      end
    end
  end
end
