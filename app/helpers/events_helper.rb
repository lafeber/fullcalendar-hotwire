module EventsHelper
  def date_plus_time(date, time)
    DateTime.new(date.year, date.month, date.day, time.hour, time.min, 0)
  end

  def occurrence_attributes(event, date)
    event.attributes
      .except("id", "created_at", "updated_at", "recurring", "ends_at", "starts_at")
      .merge(event.recurring)
      .merge(start: date_plus_time(date, event.starts_at), end: date_plus_time(date, event.ends_at))
      .transform_keys(&:to_sym)
  end
end
