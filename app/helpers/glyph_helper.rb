module GlyphHelper
  # ==== Examples
  # glyph(:share_alt)
  # # => <span class="icon-share-alt"></span>
  # glyph(:lock, :white)
  # # => <span class="icon-lock icon-white"></span>
  # glyph(:thumbs_up, :pull_left)
  # # => <i class="icon-thumbs-up pull-left"></i>
  # glyph(:lock, {tag: :span})
  # # => <span class="icon-lock"></span>
  def glyph(*names)
    names.map! { |name| name.to_s.gsub('_','-') }
    names.map! do |name|
      name =~ /pull-(?:left|right)/ ? name : "fa fa-#{name}"
    end
    # <i class="fa fa-camera-retro"></i> 
    content_tag :i, nil, :class => names
  end
end
