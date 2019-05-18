# frozen_string_literal: true

module Api::Controllers::Conditions
  class GuessDislike
    include Api::Action
    accept :json

    expose :conditions
    before :configure_response

    params do
      required(:user_id).filled
    end

    def call(params)
      halt 400 unless params.valid?

      @conditions = GuessCondition.new.dislike_conditions(params.get(:user_id))
    end

    private

    def configure_response
      self.status = 200
    end
  end
end
