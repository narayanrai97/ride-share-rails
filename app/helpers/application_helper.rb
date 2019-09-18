module ApplicationHelper

  def pass_fail(application_state)
    application_state ? "passed" : "failed"
  end

end
