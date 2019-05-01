# frozen_string_literal: true

require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :shops

  def call(params)
    # shops = recommend(user_id, params.words)
  end

  private

  def recommend(user, search_word)
    # いろいろやる

    conditions = {
      'small_area' => '',
      'genre' => '',
      'card' => 0
    }

    shops = get_shops(search_word, conditions)
  end

  def get_shops(words, conditions)
    require 'net/http'
    require 'json'

    uri = URI.parse(URI.parse(ENV['HOTPEPPER_HOST']))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === "https"

    headers = {
        'Content-Type' => 'application/json',
        'key' => ENV['HOTPEPPER_API_KEY'],
        'format' => 'json',
        'keyword' => words.join(' ')
    }.merge(conditions)

    response = http.get(uri.path, headers)

    return nil if response.code != 200

    JSON.parse(response.body)['results']['shop']
  end
end
