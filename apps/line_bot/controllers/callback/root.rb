module LineBot::Controllers::Callback
  class Root
    require 'line/bot'
    require_relative 'reply_test'

    include LineBot::Action
    accept :json

    def client
      @client ||= Line::Bot::Client.new do |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      end
    end

    def call(_params)
      body = request.body.read

      signature = request.env['HTTP_X_LINE_SIGNATURE']
      status 400, 'Bad request' unless client.validate_signature(body, signature)

      events = client.parse_events_from(body)

      events.each do |event|
        line_user_id = event['source']['userId']
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
              message = check_lexical(event.message['text'])
              if message
                client.reply_message(event['replyToken'], message)
                return true
              end
            end

            # Hanami.logger.debug event.message['text']

            message = if event.message['text'] == 'お寿司'
                        get_recommend_sample(1, event.message['text'])
                      else
                        get_quick_reply_test
                      end

            client.reply_message(event['replyToken'], message)
          end
        end
      end

      status 200, 'ok'
    end

    private

    def check_lexical(word)
      case word
        when 'テキスト' then get_text_reply_test
        when 'Datepicker' then get_datepicker_test
        else nil
      end
    end
  end
end
