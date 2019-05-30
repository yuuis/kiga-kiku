require_relative './budget'
require_relative './large_area'
require_relative './service_area'
require_relative './service_area'
require_relative './shop'
require_relative './shop_genre'
require_relative './small_area'
require_relative './user'
require_relative './user_went_shop'
require_relative './feedback'
require_relative './condition'

SmallAreaSeed.new.call
LargeAreaSeed.new.call
ServiceAreaSeed.new.call
BudgetSeed.new.call
ShopGenreSeed.new.call
ShopSeed.new.call
UserSeed.new.call
UserWentShopSeed.new.call
FeedbackSeed.new.call
ConditionSeed.new.call
