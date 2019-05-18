require_relative '../../config/boot'
require 'net/http'
require 'json'
require 'uri'

class ShopGenreSeed
  def call
    uri = URI.parse(ENV['HOTPEPPER_HOST'])
    http = Net::HTTP.new(uri.host, uri.port)

    params = {
      key: ENV['HOTPEPPER_API_KEY'],
      format: 'json'
    }

    response = http.get(uri.path + '/genre/v1?' + URI.encode_www_form(params))

    puts "cant get genres. received: #{response.code}" if response.code != '200'

    JSON.parse(response.body)['results']['genre'].each do |genre|
      ShopGenreRepository.new.create(code: genre['code'], name: genre['name'])
    end
  end
end
