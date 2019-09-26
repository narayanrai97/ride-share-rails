module ApplicationHelper

  def pass_fail(application_state)
    application_state ? "passed" : "failed"
  end

  def driver_active_inactive(is_active)
    is_active ? "Yes" : "No"
  end

end
