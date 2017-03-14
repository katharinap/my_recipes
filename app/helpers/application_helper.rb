# frozen_string_literal: true
module ApplicationHelper
  include GlyphHelper

  def current_user_id
    current_user.try :id
  end

  def nav_link_to(path, icon, text, opts = {})
    small = nav_link_to_on_small(path, icon, text, opts)
    med = nav_link_to_on_med(path, icon, text, opts)
    small + med
  end

  def nav_link_to_on_small(path, icon, text, opts)
    opts[:class] = 'nav-link'
    content_tag :li, class: 'nav-item' do
      content_tag :div, class: 'hidden-md-up' do
        link_to path, opts, title: text do
          glyph("#{icon} fa-fw")
        end
      end
    end
  end

  def nav_link_to_on_med(path, icon, text, opts)
    opts[:class] = 'nav-link'
    content_tag :li, class: 'nav-item' do
      content_tag :div, class: 'hidden-sm-down' do
        link_to path, opts do
          glyph("#{icon} fa-fw") + text
        end
      end
    end
  end
end
