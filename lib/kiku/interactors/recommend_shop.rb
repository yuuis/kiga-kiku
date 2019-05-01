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

  def recommend(user, search_word)

  end
end
