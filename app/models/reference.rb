# == Schema Information
#
# Table name: references
#
#  id         :integer          not null, primary key
#  recipe_id  :integer
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Reference < ApplicationRecord
  belongs_to :recipe
end
