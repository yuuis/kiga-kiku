# frozen_string_literal: true

require_relative '../../../../batch/specify_locations_for_all_users'

module Api::Controllers::Locations
  class Specify
    include Api::Action
    accept :json

    before :configure_response

    def call(_params)
      users = UserRepository.new.all

      users.each do |user|
        SpecifyLocations.new.call(user.id)
      end
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
