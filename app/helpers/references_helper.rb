module ReferencesHelper
  def display_reference(reference)
    if url?(reference.location)
      link_to reference.location, reference.location.html_safe
    else
      reference.location
    end
  end

  def url?(location)
    # http://www.regexguru.com/2008/11/detecting-urls-in-a-block-of-text/
    location =~ %r{(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#\/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[A-Z0-9+&@#\/%=~_|$])}i
  end
end
