module Api::Views::UserWentShops
  class Create
    include Api::View
    layout false

    def render
      user_went_shop.nil? ? '[]' : _raw(user_went_shop.to_h.to_json)
    end
  end
end
