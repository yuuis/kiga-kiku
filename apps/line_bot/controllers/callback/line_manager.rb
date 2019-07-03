require_relative 'watson_parse'
require 'line/bot'

class LineManager
  attr_reader :events

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def initialize(body)
    @request = body
    @events = client.parse_events_from(body)

    @line_id = @events.first['source']['userId']
    @profile = JSON.parse(client.get_profile(@line_id).read_body)
    @display_name = @profile['displayName']
    @user = UserLineUserRelRepository.new.find_by_line_user_id(@line_id)
  end

  def signature?(signature)
    client.validate_signature(@request, signature)
  end

  def user_id
    @user.user_id unless @user.blank?
  end

  def registered?
    !@user.blank?
  end

  def user_register
    user = UserRepository.new.create(name: @display_name)
    UserLineUserRelRepository.new.create(user_id: user.id, line_user_id: @line_id)
  end

  
  def symbolize_keys(hash)
    hash.map{|k,v| [k.to_sym, v] }.to_h
  end
end
