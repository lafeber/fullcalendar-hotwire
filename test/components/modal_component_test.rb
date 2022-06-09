# frozen_string_literal: true

require "test_helper"

class ModalComponentTest < ViewComponent::TestCase
  def test_title
    render_inline(ModalComponent.new(title: "Hello, components!"))
    assert_selector "h2", text: "Hello, components!"
  end
end
