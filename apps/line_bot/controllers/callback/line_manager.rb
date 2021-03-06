require 'line/bot'

class LineManager
  attr_reader :events

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      config.endpoint = 'http://host.docker.internal:8080' if dummy_token?(@request)
    end
  end

  def initialize(body)
    @request = body
    @events = client.parse_events_from(body)

    @line_id = @events.first['source']['userId']
    @profile = JSON.parse(client.get_profile(@line_id).read_body)
    @display_name = @profile['displayName']
    user_line_rel = UserLineUserRelRepository.new.find_by_line_user_id(@line_id)
    @user = user_line_rel.to_user unless user_line_rel.nil?
  end

  def signature?(signature)
    client.validate_signature(@request, signature)
  end

  def user_id
    @user.id unless @user.blank?
  end

  def registered?
    !@user.blank?
  end

  def user_register
    user = UserRepository.new.create(name: @display_name)
    UserLineUserRelRepository.new.create(user_id: user.id, line_user_id: @line_id)
  end

  private

  def dummy_token?(body)
    JSON.parse(body)['events'].first['replyToken'] == 'dummyToken'
  end
end
