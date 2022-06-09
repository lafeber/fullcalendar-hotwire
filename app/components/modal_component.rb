# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
