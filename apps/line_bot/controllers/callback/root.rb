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
        userid = event['source']['userId']
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
            reply_debug = true 
            if reply_debug 
              message = checkLexical(event.message['text'])
              if message
                client.reply_message(event['replyToken'], message)
                return true
              end
            end


            # Hanami.logger.debug event.message['text']

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


    private
    def checkLexical(word)
      case word
        when "テキスト"
          return getTextReplyTest
        when "Datepicker"
          return getDatepickerTest
      end
      return nil
    end
  end  
end
