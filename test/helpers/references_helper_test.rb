require File.expand_path("../../test_helper", __FILE__)

class ReferencesHelperTest < ActionView::TestCase
  context '.display_reference' do
    should 'create a hyperlink if the reference is a url' do
      reference = 'wwww.goodfood.com'
      expected_str = '<a href="wwww.goodfood.com">wwww.goodfood.com</a>'
      assert_equal expected_str, display_reference(reference)
    end

    should 'create a simple reference without hyperlink if the reference is not a url' do
      reference = 'Favorite Cookbook p. 77'
      expected_str = 'Favorite Cookbook p. 77'
      assert_equal expected_str, display_reference(reference)
    end
  end
end
