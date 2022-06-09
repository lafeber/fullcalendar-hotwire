# frozen_string_literal: true

class NoticeComponent < ViewComponent::Base
  def initialize(notice:)
    @notice = notice
  end
end
