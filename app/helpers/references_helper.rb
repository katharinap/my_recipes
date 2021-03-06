# frozen_string_literal: true
module ReferencesHelper
  def display_reference(reference)
    if url?(reference)
      link_to reference, reference.html_safe
    else
      reference
    end
  end

  def url?(reference)
    # http://www.regexguru.com/2008/11/detecting-urls-in-a-block-of-text/
    # rubocop:disable Metrics/LineLength
    reference =~ %r{(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#\/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[A-Z0-9+&@#\/%=~_|$])}i
    # rubocop:enable Metrics/LineLength
  end
end
