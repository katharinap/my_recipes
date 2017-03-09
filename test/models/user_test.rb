# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  authentication_token   :string(30)
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require File.expand_path("../../test_helper", __FILE__)

class UserTest < ActiveSupport::TestCase
  should 'be valid' do
    assert create(:user).valid?
  end
  
  context '.reset_authentication_token!' do
    should 'reset the authentication token' do
      user = User.new(name: 'me', email: 'me@email.com', authentication_token: 'abcdefgh12345678')
      user.reset_authentication_token!
      refute_equal 'abcdefgh12345678', user.authentication_token
    end

    should 'set the authentication_token if it was not set before' do
      user = User.new(name: 'me2', email: 'me2@email.com')
      user.reset_authentication_token!
      refute_nil user.authentication_token
    end
  end
end
