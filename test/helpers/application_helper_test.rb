require File.expand_path("../../test_helper", __FILE__)

class ApplicationHelperTest < ActionView::TestCase
  test 'nav_link_to' do
    return_val = nav_link_to(root_path, :home, 'Home')
    expected_result = '<li class="nav-item"><div class="hidden-md-up"><a class="nav-link" href="/"><i class="fa fa-home fa-fw" aria-hidden="true"></i></a></div></li><li class="nav-item"><div class="hidden-sm-down"><a class="nav-link" href="/"><i class="fa fa-home fa-fw" aria-hidden="true"></i>Home</a></div></li>'
    assert_equal return_val, expected_result
  end
end
