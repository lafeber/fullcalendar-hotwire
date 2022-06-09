require "test_helper"

class EventTest < ActiveSupport::TestCase
  test 'valid event' do
    event = events(:one)
    assert event.valid?
  end

  test 'title presence' do
    event = Event.new(title: '')
    refute event.valid?
  end

  test 'end before start' do
    event = Event.new(title: 'hi', start: 1.day.from_now, end: 1.day.ago)
    refute event.valid?
  end
end
