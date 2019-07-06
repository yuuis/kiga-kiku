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

      location = LocationRepository.new.latest(params.get(:user_id))
      unless location.nil?
        latitude = location.latitude
        longitude = location.longitude
      end

      @shops = RecommendShop.new.call(params.get(:user_id), params.get(:words).split(','), latitude, longitude).recommend_result
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
