# == Schema Information
#
# Table name: references
#
#  id         :integer          not null, primary key
#  recipe_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  location   :string
#
require 'test_helper'

class ReferenceTest < ActiveSupport::TestCase
  should belong_to :recipe

  should 'be valid' do
    assert references(:goodfood).valid?
  end
end