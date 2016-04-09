# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Recipe < ApplicationRecord
  belongs_to :user

  DEPENDENT_ATTRIBUTES = {
    ingredients: :value,
    steps: :description,
    references: :location,
  }

  # FIXME - uniqueness still OK?
  validates :name, uniqueness: true, presence: true

  DEPENDENT_ATTRIBUTES.each do |dependent, attr|
    has_many dependent, dependent: :destroy
    accepts_nested_attributes_for dependent,
                                  allow_destroy: true,
                                  reject_if: -> (params) { params[attr].blank? }
  end

  # has_many :ingredients, dependent: :destroy
  # has_many :steps, dependent: :destroy
  # has_many :references, dependent: :destroy

  # accepts_nested_attributes_for :ingredients, allow_destroy: true
  # accepts_nested_attributes_for :steps, allow_destroy: true
  # accepts_nested_attributes_for :references, allow_destroy: true

  def user_name
    user ? user.email : 'N/A'
  end

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
