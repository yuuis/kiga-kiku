# frozen_string_literal: true

require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :shops

  def initialize
    # set up the object
  end

  def call(params)

  end

  private

  def recommend(day_of_the_week, user = nil, lat = nil, lng = nil)

  end
end
