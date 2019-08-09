# frozen_string_literal: true

module Api::Controllers::UserWents
  class Create
    include Api::Action
    accept :json

    expose :user_went
    before :configure_response

    params do
      required(:user_id).filled
      required(:shop_id).filled
    end

    def call(params)
      halt 400 unless params.valid?

      @uesr_went = UserWentShopRepository.new.create(user_id: params.get(:user_id), shop_id: params.get(:shop_id))
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
