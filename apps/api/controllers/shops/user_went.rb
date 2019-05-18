# frozen_string_literal: true

module Api::Controllers::Shops
  class UserWent
    include Api::Action
    accept :json

    expose :shops
    before :configure_response

    params do
      required(:user_id).filled
    end

    def call(params)
      halt 400 unless params.valid?

      @shops = UserWentShopInteractor.new.call(params.get(:user_id))
    end

    private

    def configure_response
      self.status = 200
    end
  end
end

