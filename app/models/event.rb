class Event < ApplicationRecord
  validates :title, presence: true
  validates_comparison_of :end, greater_than: :start

  RECURRING_FIELDS = %i[every interval until on].freeze

  alias_attribute :start, :starts_at
  alias_attribute :end, :ends_at

  store_accessor :recurring, *RECURRING_FIELDS

  scope :single, -> { where(recurring: nil) }
  scope :single_in_period, ->(starts_at, ends_at) {
    single.where(starts_at: starts_at..ends_at).or(
      Event.single.where(ends_at: starts_at..ends_at)
    )
  }

  scope :recurring, -> { where.not(recurring: nil) }

  def editable
    recurring.blank?
  end

  # Loop over all event that have a start date before the period end
  # Convert the occurrences for that event back to the event
  def self.recurring_in_period(period_starts_at, period_ends_at)
    single_events = []
    Event.recurring.where(starts_at: ..period_ends_at).each do |event|
      r = Recurrence.new(
        every: event.every,
        on: event.on || (event.starts_at.strftime("%w").to_i + 1),
        starts: period_starts_at.to_datetime,
        until: period_ends_at.to_datetime)
      r.events(starts: period_starts_at, until: period_ends_at).each do |date|
        single_events << Event.new(
          id: event.id,
          starts_at: date_plus_time(date, event.starts_at),
          ends_at: date_plus_time(date, event.ends_at),
          title: event.title,
          color: event.color,
          recurring: "{ editable: false }",
          all_day: event.all_day)
      end
    end
    single_events
  end

  def self.date_plus_time(date, time)
    DateTime.new(date.year, date.month, date.day, time.hour, time.min, 0)
  end
end
