module EventsHelper
  def date_plus_time(date, time)
    DateTime.new(date.year, date.month, date.day, time.hour, time.min, 0)
  end
end
