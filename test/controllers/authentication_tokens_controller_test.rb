class AuthenticationTokensControllerTest < ActionController::TestCase
  test 'PATCH update' do
    user = User.create(email: 'someone@example.com', password: 'lalala1234', authentication_token: '1234lalala')
    sign_in user
    request.env['HTTP_REFERER'] = 'http://test.com/'
    patch :update, { user_id: user.id }
    user = User.find(user.id)
    refute_equal '1234lalala', user.authentication_token
  end
end
