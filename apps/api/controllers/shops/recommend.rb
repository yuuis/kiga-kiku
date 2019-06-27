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

      location = LocationRepository.new.find(user_id: params.get(:user_id))
      latitude, longitude = location.latitude, location.longitude unless location.nil?

      @shops = RecommendShop.new.call(user_id = params.get(:user_id), words = params.get(:words).split(','), latitude = latitude, longitude = longitude)
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
