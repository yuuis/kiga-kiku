module LineBot::Controllers::Callback
  class Root
    require 'line/bot'
    require_relative 'ReplyTest'

    include LineBot::Action
    accept :json

    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end

    def call(params)
      body = request.body.read

      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        status 400, "Bad request"
      end

      events = client.parse_events_from(body)

      events.each { |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Location
            message = {
              type: 'text',
              text: event.message['address']
            }
            client.reply_message(event['replyToken'], message)
            break
          when Line::Bot::Event::MessageType::Text

            # @shops = RecommendShop.new.call(params.get(event.source.userId), params.get(:words).split(','))

            Hanami.logger.debug event.message['text']

            if event.message['text'] == "お寿司"
               message = getRecommendSample(event.message['text'])
            else 
              message = getQuickReplyTest
            end


            client.reply_message(event['replyToken'], message)
          end
        end
      }

      status 200, "ok"
    end
  end
end
