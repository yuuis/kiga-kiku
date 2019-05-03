# frozen_string_literal: true

module Api::Controllers::Shops
  class Recommend
    include Api::Action
    accept :json

    expose :shops
    before :configure_response

    params do
      required(:user_id).filled
      required(:words).filled
    end

    def call(params)
      halt 400 unless params.valid?

      @shops = RecommendShop.new.call(params.get(:user_id), params.get(:words).split(','))
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
