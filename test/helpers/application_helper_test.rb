require File.expand_path("../../test_helper", __FILE__)

class ApplicationHelperTest < ActionView::TestCase
  test 'nav_link_to' do
    return_val = nav_link_to root_path do
      "My Block"
    end
    expected_result = "<a class=\"dropdown-item nav-link\" href=\"/\">My Block</a>"
    assert_equal return_val, expected_result
  end
end
