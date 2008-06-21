# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_action
    [ controller.controller_name.titleize, controller.action_name.titleize ].join(' - ')
  end
end
