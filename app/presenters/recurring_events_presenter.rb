# frozen_string_literal: true

module RecurringEventsPresenter
  attr_reader :event, :starts_at, :ends_at

  def initialize(event, starts_at, ends_at)
    @event = event
    @starts_at = starts_at
    @ends_at = ends_at
  end
end
