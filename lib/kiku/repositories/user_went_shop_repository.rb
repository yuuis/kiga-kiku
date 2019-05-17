# frozen_string_literal: true

class UserWentShopRepository < Hanami::Repository
  associations do
    belongs_to :user
    belongs_to :shop
  end

  def recent(user, limit: 3)
    user_went_shops
      .where(user_id: user.id)
      .order(:created_at)
      .limit(limit)
  end
end
