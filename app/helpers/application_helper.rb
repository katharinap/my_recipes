module ApplicationHelper
  def current_user_id
    current_user.try :id
  end

  def nav_link_to(name=nil, path="#", *args, &block)
    path = name || path if block_given?
    options = { class: 'dropdown-item nav-link' }
    if block_given?
      link_to path, options, &block
    else
      link_to name, path, options
    end
  end
end
