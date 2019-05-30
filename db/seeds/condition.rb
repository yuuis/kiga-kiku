require_relative '../../config/boot'
require 'json'

class ConditionSeed
  def call
    ConditionRepository.new.create(feedback_id: 1, conditions: { wifi: 1, course: 1 }.to_json)
    ConditionRepository.new.create(feedback_id: 2, conditions: { free_food: 0, private_room: 0 }.to_json)
  end
end
