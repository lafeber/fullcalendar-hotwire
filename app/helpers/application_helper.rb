module ApplicationHelper
  def calendar_image
    "//ssl.gstatic.com/calendar/images/dynamiclogo_2020q4/calendar_#{Time.zone.now.day}_2x.png"
  end
end
