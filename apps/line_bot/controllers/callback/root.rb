module LineBot::Controllers::Callback
  class Root
    require 'line/bot'
    require 'ibm_watson/assistant_v2'
    require 'uri'

    include LineBot::Action
    accept :json

    # rubocop:disable all
    # いつかきれいにするから許してくれ……
    def call(_params)
      body = request.body.read
      line = CreateReplyMessage.new(body)

      # LINEからのヘッダー解析
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      status 400, 'Bad request' unless line.signature?(signature)

      watson = WatsonParser.new

      line.events.each do |event|
        case event

        when Line::Bot::Event::Follow
          unless line.registered?
            line.user_register

            line.register_thanks_reply
            line.send_message(event)
          end

        when Line::Bot::Event::Postback
          postback = query_to_hash(event['postback']['data'])

          case postback['method']
          when 'wentshop'
            return nil if postback['shop_id'].blank?
            # user_wentを登録
            UserWentShopRepository.new.create(user_id: line.user_id, shop_id: postback['shop_id'])
          end

        when Line::Bot::Event::Message
          return line.cannot_get_user_id if line.user_id.nil? # LINEID -> UserIDに変換できなかった時の例外処理

          line.user_send_message(event)

          case event.type
          when Line::Bot::Event::MessageType::Text, Line::Bot::Event::MessageType::Location
            if event.type === Line::Bot::Event::MessageType::Location
              LocationRepository.new.create(
                user_id: line.user_id,
                latitude: event.message['latitude'],
                longitude: event.message['longitude'],
                altitude: 0,
                activity_type: 'stop',
                uuid: ''
              )
              line.user_message = 'LOCATION_TRIGGER'
            end

            # 文章解析を行う
            # 1. セッションを生成
            watson.create_new_session
            # 2. セッション情報を入力してレスポンスを受け取る
            watson.request_analysis(line.user_message)
            # 3. 解析結果を返信文章生成クラスに送る
            line.register_watson(watson)

            # Hanami.logger.debug watson_result.to_json

            line.auto_generate_message_reply

            # 最後に送信
            line.send_message(event)
          end
        end
      end

      status 200, 'ok'
    end
    # rubocop:enable all

    private

    def check_lexical(word)
      case word
      when 'テキスト' then get_text_reply_test
      when 'Datepicker' then get_datepicker_test
      end
    end

    def query_to_hash(str)
      Hash[URI.decode_www_form(str)]
    end
  end
end
