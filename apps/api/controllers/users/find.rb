# frozen_string_literal: true

module Api::Controllers::Users
  class Find
    include Api::Action
    accept :json

    expose :user_id
    before :configure_response

    params do
      required(:line_user_id).filled
    end

    def call(params)
      halt 400 unless params.valid?
      rel = UserLineUserRelRepository.new.find(line_user_id: params.get(:line_user_id))

      @user_id = rel.user_id unless rel.nil?
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
