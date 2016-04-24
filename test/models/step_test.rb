# == Schema Information
#
# Table name: steps
#
#  id          :integer          not null, primary key
#  recipe_id   :integer
#  idx         :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  picture     :string
#
require File.expand_path("../../test_helper", __FILE__)

class StepTest < ActiveSupport::TestCase
  should belong_to :recipe

  should 'be valid' do
    assert steps(:step_1).valid?
  end

  should 'be invalid without a description' do
    steps(:step_1).description = nil
    assert steps(:step_1).invalid?
  end
end