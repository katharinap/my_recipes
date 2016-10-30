require File.expand_path("../../test_helper", __FILE__)

class DurationHelperTest < ActionView::TestCase
  context '.minutes_in_words' do
    should 'return minutes if the duration is less than an hour' do
      assert_equal '1 minute', minutes_in_words(1)
      assert_equal '25 minutes', minutes_in_words(25)
      assert_equal '1m', minutes_in_words(1, short: true)
      assert_equal '25m', minutes_in_words(25, short: true)
    end

    should 'return hours and minutes if the duration is more than one hour' do
      assert_equal '1 hour 15 minutes', minutes_in_words(75)
      assert_equal '2 hours 30 minutes', minutes_in_words(150)
      assert_equal '2h 30m', minutes_in_words(150, short: true)
    end

    should 'return hours if the duration is for full hours' do
      assert_equal '1 hour', minutes_in_words(60)
      assert_equal '2 hours', minutes_in_words(120)
    end

    should 'return N/A if the argument is not a number' do
      assert_equal 'N/A', minutes_in_words(nil)
      assert_equal 'N/A', minutes_in_words('123')
    end
  end
end
