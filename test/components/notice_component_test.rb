# frozen_string_literal: true

require "test_helper"

class NoticeComponentTest < ViewComponent::TestCase
  def test_notice
    render_inline(NoticeComponent.new(notice: "Hello, components!"))
    assert_selector "p", text: "Hello, components!"
  end
end
