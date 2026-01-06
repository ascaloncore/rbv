# frozen_string_literal: true

module StocksHelper
  def status_badge_class(status)
    case status
    when "unstarted"
      "badge-warning"
    when "in_progress"
      "badge-info"
    when "completed"
      "badge-success"
    else
      "badge-ghost"
    end
  end
end

