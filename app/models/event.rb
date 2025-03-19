class Event < ApplicationRecord
  validates :title, presence: true
  validates_comparison_of :end, greater_than: :start

  has_many :exceptions, class_name: "Event", foreign_key: "parent_id", dependent: :destroy

  RECURRING_FIELDS = %i[every interval until on except].freeze

  alias_attribute :start, :starts_at
  alias_attribute :end, :ends_at

  attr_accessor :event_until_id

  store_accessor :recurring, *RECURRING_FIELDS

  scope :single, -> { where(recurring: nil) }
  scope :recurring, -> { where(parent_id: nil).where.not(recurring: nil) }
  scope :starts_at_in_period, ->(starts_at, ends_at) { where(starts_at: starts_at..ends_at) }
  scope :ends_at_in_period, ->(starts_at, ends_at) { where(ends_at: starts_at..ends_at) }
  scope :overlapping_period, ->(starts_at, ends_at) { where(starts_at: ..starts_at, ends_at: ends_at..) }

  # Either the start is in the period, the end is in it, or start is before ane end is after
  scope :single_in_period, ->(starts_at, ends_at) {
    single.starts_at_in_period(starts_at, ends_at)
    .or(single.ends_at_in_period(starts_at, ends_at))
    .or(single.overlapping_period(starts_at, ends_at))
  }

  # 'editable' is a fullcalendar method; can you drag the event around?
  def editable
    recurring.blank?
  end

  def self.in_period(starts_at, ends_at)
    Event.single_in_period(starts_at, ends_at).to_a
      .concat(RecurringEventsPresenter.new(starts_at, ends_at).events)
  end
end
