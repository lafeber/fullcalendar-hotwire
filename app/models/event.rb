class Event < ApplicationRecord
  validates :title, presence: true
  validates_comparison_of :end, greater_than: :start

  RECURRING_FIELDS = %i[every interval until on].freeze

  store_accessor :recurring, *RECURRING_FIELDS
end
