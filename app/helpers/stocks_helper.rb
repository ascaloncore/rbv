# frozen_string_literal: true

module StocksHelper
  def status_badge_class(status)
    case status
    when "unread", "reading"
      "bg-[#00F0FF]/20 text-[#00F0FF] border border-[#00F0FF]/50"        # 適正在庫 - ネオンシアン
    when "stagnant"
      "bg-[#FBBF24]/20 text-[#FBBF24] border border-[#FBBF24]/50"        # 滞留在庫 - 警告（黄色）
    when "suspended", "impaired"
      "bg-[#EF4444]/20 text-[#EF4444] border border-[#EF4444]/50"        # 不良在庫/読書撤退損 - エラー（赤）
    when "completed"
      "bg-[#10B981]/20 text-[#10B981] border border-[#10B981]/50"        # 知識資産 - 成功（緑）
    else
      "bg-[#1A1C23] text-[#94A3B8] border border-[#2E323A]"
    end
  end
end
