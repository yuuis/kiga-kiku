# frozen_string_literal: true

require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :shops

  def call(user, params)
    # shops = recommend(user.id, params.words)
  end

  private

  def recommend(_user, search_word)
    # いろいろやる

    conditions = {
      # 'small_area' => '',
      # 'genre' => '',
      # 'card' => 0,
      'keyword' => search_word.join(' ')
    }

    shops = get_shops(conditions)
  end

  def get_shops(conditions)
    require 'net/http'
    require 'json'

    uri = URI.parse(ENV['HOTPEPPER_HOST'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false

    headers = {
      'Content-Type' => 'application/json'
    }

    params = {
      'key' => ENV['HOTPEPPER_API_KEY'],
      'format' => 'json'
    }.merge(conditions)

    response = http.get(uri.path + '?' + hash_to_query(params), headers)

    return nil if response.code != 200

    JSON.parse(response.body)['results']['shop']
  end

  def hash_to_query(hash)
    URI.encode(hash.map { |k, v| "#{k}=#{v}" }.join('&'))
  end
end
