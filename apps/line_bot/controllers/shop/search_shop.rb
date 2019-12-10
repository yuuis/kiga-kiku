class SearchShop
  def last_user_went_shop(user)
    return nil if user.nil?

    user_whent_shop = UserWentShopRepository.new.recent(user, limit: 1)
    ShopRepository.new.find(user_whent_shop.first.shop_id) unless user_whent_shop.blank?
  end
end
