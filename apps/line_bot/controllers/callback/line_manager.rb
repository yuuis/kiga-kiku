require_relative 'watson_parse'
require 'line/bot'

class LineManager
  
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
    @display_name = client.get_profile(@line_id)
    @user = UserLineUserRelRepository.new.find(line_user_id: @line_id)
    
    @user_message = @events.first.message['text']  # ユーザーが送ってきたメッセージ
  end

  def hasSignature(signature)
    client.validate_signature(@request, signature)
  end

  def get_user_id
    @user.blank? ? nil : @user.user_id
  end

  def get_events
    @events
  end

  def registered?
    !@user.blank?
  end

  def user_register
    @user = UserRepository.new.create(name: @display_name)
    UserLineUserRelRepository.new.create(user_id: @user.id, line_user_id: @line_id)
  end

end
