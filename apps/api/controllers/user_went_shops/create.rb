# frozen_string_literal: true

module Api::Controllers::UserWentShops
  class Create
    include Api::Action
    accept :json

    expose :user_went_shop
    before :configure_response

    def call(params)
      body = request.env['router.params']
      halt 400 if body[:user_id].nil? || body[:shop_id].nil?

      @user_went_shop = UserWentShopRepository.new.create(user_id: params.get(:user_id), shop_id: params.get(:shop_id))
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
