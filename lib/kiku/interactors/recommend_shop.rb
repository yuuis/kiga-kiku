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
    # レコメンド条件
    # * ユーザのフィードバックの良い条件をconditionsに足す
    # * 曜日によって、ご飯か居酒屋かを変えてconditionsに足す
    # * 時間帯によって、深夜営業している条件をconditionsに足す

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
    require 'uri'

    uri = URI.parse(ENV['HOTPEPPER_HOST'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false

    headers = {
      'Content-Type' => 'application/json'
    }

    params = {
      'key' => ENV['HOTPEPPER_API_KEY'],
      'format' => 'json',
      'count' => 3,
    }.merge(conditions)

    response = http.get(uri.path + '?' + hash_to_query(params), headers)

    return nil if response.code != 200

    JSON.parse(response.body)['results']['shop']
  end

  def hash_to_query(hash)
    URI.encode(hash.map { |k, v| "#{k}=#{v}" }.join('&'))
  end
end
