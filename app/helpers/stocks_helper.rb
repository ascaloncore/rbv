# frozen_string_literal: true

module StocksHelper
  def status_badge_class(status)
    case status
    when "unread"
      "badge-info"        # 適正在庫 - 青
    when "reading"
      "badge-primary"     # 適正在庫 - プライマリ
    when "stagnant"
      "badge-warning"     # 滞留在庫 - 警告（黄色）
    when "suspended"
      "badge-error"       # 不良在庫 - エラー（赤）
    when "impaired"
      "badge-error"       # 読書撤退損 - エラー（赤）
    when "completed"
      "badge-success"     # 知識資産 - 成功（緑）
    else
      "badge-ghost"
    end
  end
end

