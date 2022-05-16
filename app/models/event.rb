class Event < ApplicationRecord
  validates :title, presence: true
  validates_comparison_of :end, greater_than: :start
end
