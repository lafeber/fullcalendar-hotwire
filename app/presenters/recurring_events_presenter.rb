# frozen_string_literal: true

class RecurringEventsPresenter
  include EventsHelper
  attr_reader :events, :starts_at, :ends_at

  def initialize(period_starts_at, period_ends_at)
    @period_starts_at = period_starts_at
    @period_ends_at = period_ends_at
    @events = []
  end

  # Loop over all event that have a start date before the period end
  # Convert the occurrences for that event back to the event
  def events
    Event.recurring.where(starts_at: ..@period_ends_at).each do |event|
      p event.exceptions.pluck(:starts_at)
      r = Recurrence.new(
        every: event.every,
        on: event.on.presence || (event.starts_at.strftime("%w").to_i + 1),
        starts: event.starts_at.to_datetime,
        except: event.exceptions.pluck(:starts_at).map { |e| e.strftime("%Y-%m-%d") },
        until: event.until.presence || @period_ends_at.to_datetime)
      r.events(starts: @period_starts_at, until: event.until.presence || @period_ends_at).each do |date|
        @events << Event.new(
          id: event.id,
          starts_at: date_plus_time(date, event.starts_at),
          ends_at: date_plus_time(date, event.ends_at),
          title: event.title,
          color: event.color,
          recurring: { editable: false },
          all_day: event.all_day)
      end
    end
    @events
  end
end
