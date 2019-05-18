require_relative '../../config/boot'

class UserWentShopSeed
  def call
    UserWentShopRepository.new.create(user_id: 1, shop_id: 'J001051208')
    UserWentShopRepository.new.create(user_id: 1, shop_id: 'J001215659')
    UserWentShopRepository.new.create(user_id: 2, shop_id: 'J001051208')
    UserWentShopRepository.new.create(user_id: 2, shop_id: 'J001215659')
  end
end
