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

  DEPENDENT_ATTRIBUTES = {
    ingredients: :value,
    steps: :description,
    references: :location,
  }

  # FIXME - uniqueness still OK?
  validates :name, uniqueness: true, presence: true

  # has_many :ingredients, dependent: :destroy
  # has_many :steps, dependent: :destroy
  # has_many :references, dependent: :destroy
  #
  # accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: -> (params) { params[value].blank? }
  # accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: -> (params) { params[description].blank? }
  # accepts_nested_attributes_for :references, allow_destroy: true, reject_if: -> (params) { params[location].blank? }
  
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
