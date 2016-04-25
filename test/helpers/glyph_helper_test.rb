require File.expand_path("../../test_helper", __FILE__)

class GlyphHelperTest < ActionView::TestCase

  test 'return the correct glyph' do
    expected_result = "<i class=\"fa fa-MY-GLYPH\" aria-hidden=\"true\"></i>"
    assert_equal expected_result, glyph("MY_GLYPH")
  end
end