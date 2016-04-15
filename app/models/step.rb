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

class Step < ActiveRecord::Base
  belongs_to :recipe

  include WithPicture
  has_default_picture_size [200, 200]
  has_thumb_picture_size [50, 50]
end
