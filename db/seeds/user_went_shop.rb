require_relative '../../config/boot'

class UserWentShopSeed
  def call
    UserWentShopRepository.new.create(user_id: 1, shop_id: 'J001051208')
  end
end
