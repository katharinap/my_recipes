module GlyphHelper
  def glyph(name)
    name = name.to_s.gsub('_','-')
    # <i class="fa fa-camera-retro" aria-hidden="true"></i>
    content_tag :i, nil, class: "fa fa-#{name}", 'aria-hidden' => true
  end
end
