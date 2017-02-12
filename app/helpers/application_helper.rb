module ApplicationHelper
  def current_user_id
    current_user.try :id
  end

  def nav_link_to(path, args = {}, &block)
    options = { class: 'dropdown-item nav-link' }.merge(args)
    link_to path, options, &block
  end
end
