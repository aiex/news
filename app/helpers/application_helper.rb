module ApplicationHelper
  def errors_for(obj)
    errors = ''
    if obj.errors.any?
      errors += "<div class='alert alert-error'><button data-dismiss='alert' "
      errors += " class='close' type='button'>x</button ><ul>"
      obj.errors.full_messages.each do |msg|
        errors += "<li>#{msg}</li>"
      end
      errors += "</ul></div>"
    end
    errors.html_safe
  end

  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end

  def format_date(date)
    date.present? ? date.strftime("%d %b, %Y at %I:%M%P") : ''
  end

  def is_active_controller?(controller_name)
    if params[:controller].eql?(controller_name)
      "<li class='active'>".html_safe
    else
      '<li>'.html_safe
    end
  end
end
