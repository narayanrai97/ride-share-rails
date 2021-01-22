module ApplicationHelper

  def pass_fail(application_state)
    application_state ? "passed" : "failed"
  end

  def driver_active_inactive(is_active)
    is_active ? "Yes" : "No"
  end

  def bootstrap_class_for(flash_type)
  case flash_type
  when "notice"
      "alert-success"
  when "error"
    "alert-danger"
  when "alert"
    "alert-info"
  else
    flash_type.to_s
    end
  end

  # def javascript(*files)
  # content_for(:head) { javascript_include_tag(*files) }
  # end

end
