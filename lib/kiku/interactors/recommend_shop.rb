# frozen_string_literal: true

require 'hanami/interactor'
require 'date'

class AddBook
  include Hanami::Interactor

  expose :shops

  def call(user, params)
    # shops = recommend(user, params.words)
  end

  private

  def recommend(user, search_word)
    conditions = {
      # 'small_area' => '',
      # 'genre' => '',
      # 'card' => 0,
      keyword: search_word.join(' ')
    }

    conditions = add_condition_tavern(conditions)
    conditions = add_condition_midnight(conditions)
    conditions = add_condition_budget(conditions, user)

    # TODO: ユーザのフィードバックの良い条件をconditionsに足す

    get_shops(conditions)
  end

  # 金曜、土曜であれば居酒屋を条件に足す
  def add_condition_tavern(conditions)
    return conditions if [0, 1, 2, 3, 4].include?(Date.today.wday)

    conditions.merge(genre: 'G001')
  end

  # 現在時刻が22:00以降であれば、深夜営業(食事も)していることを条件に足す
  def add_condition_midnight(conditions)
    return conditions if Time.now.hour.between?(0, 21)

    conditions.merge(midnight_meal: 1)
  end

  # ユーザの年齢によって予算を条件に足す
  def add_condition_budget(conditions, user)
    age = user.age

    return conditions if age > 35

    case age
    when 0..22 then conditions.merge(budget: 'B001') # ¥1501 ~ ¥2000
    when 23..29 then conditions.merge(budget: 'B002') # ¥2001 ~ ¥3000
    when 30..35 then conditions.merge(budget: 'B003') # ¥3001 ~ ¥4000
    else conditions.merge(budget: 'B008') # ¥4001 ~ ¥5000
    end

    conditions
  end

  def get_shops(conditions)
    require 'net/http'
    require 'json'
    require 'uri'

    uri = URI.parse(ENV['HOTPEPPER_HOST'])
    http = Net::HTTP.new(uri.host, uri.port)

    headers = {
      'Content-Type' => 'application/json'
    }

    params = {
      key: ENV['HOTPEPPER_API_KEY'],
      format: 'json',
      count: 3
    }.merge(conditions)

    response = http.get(uri.path + '?' + URI.encode_www_form(params), headers)

    return nil if response.code != 200

    JSON.parse(response.body)['results']['shop']
  end
end
