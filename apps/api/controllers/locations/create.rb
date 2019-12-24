# frozen_string_literal: true

module Api::Controllers::Locations
  class Create
    include Api::Action
    accept :json

    expose :location
    before :configure_response

    params do
      required(:user_id).filled
    end

    def call(params)
      halt 400 unless params.valid?

      body = request.env['router.params'][:location]
      @location = LocationRepository.new.create(
        user_id: params.get(:user_id),
        latitude: body[:coords][:latitude],
        longitude: body[:coords][:longitude],
        altitude: body[:coords][:altitude],
        activity_type: body[:activity][:type],
        uuid: body[:uuid]
      )
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
