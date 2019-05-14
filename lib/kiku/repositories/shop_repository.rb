# frozen_string_literal: true

class ShopRepository < Hanami::Repository
  associations do
    has_many :feedbacks

    belongs_to :shop_genre
    # belongs_to :small_area
    # belongs_to :large_area
    # belongs_to :service_area
    # belongs_to :budget
  end

  def user_recent(user)
    # userが行った一番最近のお店を返す。
    # 行ったをどうやって判断する？
  end
end
