module Api::Views::Shops
  class UserWent
    include Api::View
    layout false

    def render
      shops.shops.nil? ? '[]' : _raw(shops.shops.to_json)
    end
  end
end
