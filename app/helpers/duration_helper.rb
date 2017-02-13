# frozen_string_literal: true
module DurationHelper
  def minutes_in_words(number, short: false)
    return 'N/A' unless number.is_a? Numeric
    hours, minutes = number.divmod(60)
    [].tap do |str|
      str << "#{hours}#{hours_unit(hours, short)}" unless hours.zero?
      str << "#{minutes}#{minutes_unit(minutes, short)}" unless minutes.zero?
    end.join(' ')
  end

  def hours_unit(number, short)
    short ? 'h' : ' hour'.pluralize(number)
  end

  def minutes_unit(number, short)
    short ? 'm' : ' minute'.pluralize(number)
  end
end
