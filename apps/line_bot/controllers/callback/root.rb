module LineBot::Controllers::Callback
  class Root
    require 'line/bot'
    require 'ibm_watson/assistant_v2'

    require_relative 'watson_parse'

    include LineBot::Action
    accept :json

    def client
      @client ||= Line::Bot::Client.new do |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      end
    end

    def assistant
      @assistant = IBMWatson::AssistantV2.new(
        version: '2018-09-17',
        username: ENV['WATSON_USERNAME'],
        password: ENV['WATSON_PASSWORD']
      )
    end

    def call(_params)
      body = request.body.read
      line = CreateReplyMessage.new(body)

      # LINEからのヘッダー解析
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      status 400, 'Bad request' unless line.signature?(signature)

      line.events.each do |event|
        case event

        when Line::Bot::Event::Follow
          line_user_id = event['source']['userId']
          unless line.registered?
            line.user_register

            line.register_thanks_reply
            line.send_message(event)
          end

        when Line::Bot::Event::Message
          return line.cannot_get_user_id if line.user_id.nil? # LINEID -> UserIDに変換できなかった時の例外処理

          line.user_send_message(event)

          case event.type
          when Line::Bot::Event::MessageType::Location
            # WIP:最新位置情報を更新
            message = {
              type: 'text',
              text: event.message['address']
            }
            client.reply_message(event['replyToken'], message)
            break

          when Line::Bot::Event::MessageType::Text
            # 文章解析を行う
            # 1. セッションを生成
            watson_session = assistant.create_session(
              assistant_id: ENV['WATSON_ASSISTANT_ID']
            )
            # 2. セッション情報を入力してレスポンスを受け取る
            response = assistant.message(
              assistant_id: ENV['WATSON_ASSISTANT_ID'],
              session_id: watson_session.result['session_id'],
              input: { text: event.message['text'] }
            )
            watson_result = response.result

            line.register_watson_result(watson_result)
            # Hanami.logger.debug watson_result.to_json

            watson_entities = pull_entities(get_entities(watson_result))

            if watson_entities.nil?
              line.watson_text_reply
            else
              line.recommend_shop

              # # UIデバッグ用の、サンプルキーテキスト受信用 ========================
              # reply_debug = false
              # if reply_debug
              #   message << check_lexical(event.message['text'])
              #   if message
              #     client.reply_message(event['replyToken'], message)
              #     return true
              #   end
              # end
              # # ============================================================

            end

            # 最後に送信
            line.send_message(event)
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
        end
    end
  end
end
