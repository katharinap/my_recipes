module ApplicationHelper
  def current_user_id
    current_user.try :id
  end
end
