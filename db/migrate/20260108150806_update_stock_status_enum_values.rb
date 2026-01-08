# frozen_string_literal: true

class UpdateStockStatusEnumValues < ActiveRecord::Migration[8.1]
  def up
    # 既存の数値を10刻みの値に更新
    # unread: 0 → 0 (変更なし)
    # reading: 1 → 10
    # stagnant: 2 → 20
    # suspended: 3 → 30
    # impaired: 4 → 40
    # completed: 5 → 50
    execute <<-SQL
      UPDATE stocks
      SET status = CASE status
        WHEN 0 THEN 0   -- unread
        WHEN 1 THEN 10  -- reading
        WHEN 2 THEN 20  -- stagnant
        WHEN 3 THEN 30  -- suspended
        WHEN 4 THEN 40  -- impaired
        WHEN 5 THEN 50  -- completed
        ELSE status
      END
    SQL
  end

  def down
    # ロールバック時は元の値に戻す
    execute <<-SQL
      UPDATE stocks
      SET status = CASE status
        WHEN 0 THEN 0   -- unread
        WHEN 10 THEN 1  -- reading
        WHEN 20 THEN 2  -- stagnant
        WHEN 30 THEN 3  -- suspended
        WHEN 40 THEN 4  -- impaired
        WHEN 50 THEN 5  -- completed
        ELSE status
      END
    SQL
  end
end
