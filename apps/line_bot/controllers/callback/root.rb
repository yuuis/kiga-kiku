module LineBot::Controllers::Callback
  class Root
    require 'line/bot'
    require 'ibm_watson/assistant_v2'

    require_relative 'reply_test'
    require_relative 'reply_message'
    require_relative 'watson_parse'

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
      message = []

      # 先にWatsonの接続
      assistant = IBMWatson::AssistantV2.new(
        version: '2018-09-17',
        username: ENV['WATSON_USERNAME'],
        password: ENV['WATSON_PASSWORD']
      )

      # LINEからのヘッダー解析
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      status 400, 'Bad request' unless client.validate_signature(body, signature)

      # LINEからのイベントを取得
      events = client.parse_events_from(body)

      events.each do |event|
        user_id = get_user_id(event)

        case event
        when Line::Bot::Event::Follow
          if user_id.blank?
            user = UserRepository.new.create(name: 'name_1')
            UserLineUserRelRepository.new.create(user_id: user.id, line_user_id: line_user_id)

            message = get_add_friend
            client.reply_message(event['replyToken'], message)
          end
          break
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Location
            message = {
              type: 'text',
              text: event.message['address']
            }
            client.reply_message(event['replyToken'], message)
            break
          when Line::Bot::Event::MessageType::Text # テキストが送られてきた場合

            # 文章解析を行う
            # 1. セッションを生成
            watson_session = assistant.create_session(
              assistant_id: ENV['WATSON_ASSISTANT_ID']
            )
            session_id = watson_session.result['session_id']

            # 2. セッション情報を入力してレスポンスを受け取る
            response = assistant.message(
              assistant_id: ENV['WATSON_ASSISTANT_ID'],
              session_id: session_id,
              input: { text: event.message['text'] }
            )
            watson_result = response.result

            Hanami.logger.debug watson_result.to_json

            message = []

            watson_entities = pull_entities(get_entities(watson_result))
            unless watson_entities.nil?

              # watsonによる返信文を生成して格納
              message << get_message(event, watson_result)

              if watson_entities.include?('メニュー')
                message << get_recommend(event, watson_result)
              elsif watson_entities.include?('起動ワード')
                message << get_first_recommend(event) # .merge(get_quick_reply(['もっと安い', '近くのお店']))
              end

              # UIデバッグ用の、サンプルキーテキスト受信用 ========================
              reply_debug = false
              if reply_debug
                message << check_lexical(event.message['text'])
                if message
                  client.reply_message(event['replyToken'], message)
                  return true
                end
              end
              # ============================================================

            end

            # 最後に送信
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
        end
    end
  end
end
