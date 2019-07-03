require_relative 'watson_parse'
require_relative 'line_manager'
require 'line/bot'

class CreateReplyMessage < LineManager
  def initialize(body)
    super
    @reply_message = []
  end

  def user_send_message(event)
    @user_message = event.message['text'] unless event === Line::Bot::Event::Message
  end

  # リプライメッセージを初期化
  def reset_reply_message
    @reply_message = []
  end

  def reply_message_text
    text_reply = @reply_message.find { |item| item[:type] === 'text' }
    text_reply[:text] unless text_reply.nil?
  end

  def send_message(event)
    client.reply_message(event['replyToken'], @reply_message)
  end

  # Watsonからの応答をもらう
  def register_watson_result(watson_result)
    @watson_result = watson_result
  end

  # Watsonのテキストリプライを設定
  def watson_text_reply
    unless @watson_result.blank?
      @reply_message << {
        type: 'text',
        text: get_reply_text(@watson_result)
      }
    end
  end

  # レコメンド実行
  def recommend_shop
    return if @watson_result.blank?

    watson_text_reply
    watson_entities = pull_entities(get_entities(@watson_result))

    # Transaction and Conversation
    recommend_transaction_repository = RecommendTransactionRepository.new
    recommend_conversation_repository = RecommendConversationRepository.new
    
    transaction = recommend_transaction_repository.find_by_user_id(user_id)
    conversation = recommend_conversation_repository.find_by_transaction(transaction) unless transaction.nil?

    transaction = recommend_transaction_repository.create(user_id: user_id) if transaction.nil?

    if watson_entities.include?('精度向上キーワード')
      words = ['ラーメン'] # WIP:前回のワードを取得

      user_request = 'もっと安い' # WIP:ユーザが送ってきた要望「もっと**」
      past_conditions = ConditionRepository.new.condition_checks(user_request, keyword: 'ラーメン') # WIP: conditionを取得して格納

    elsif watson_entities.include?('メニュー')
      words = get_origin_entities(@user_message, @watson_result, 'メニュー') # watsonのメニューに引っかかった
    elsif watson_entities.include?('起動ワード')
      # WIP: 時間によって変更
      words = ['ラーメン']
    end

    location = LocationRepository.new.latest(user_id)
    unless location.nil?
      latitude = location.latitude
      longitude = location.longitude
    end

    recommend = RecommendShop.new.call(self.user_id, words, latitude, longitude, past_conditions)
    return cannot_found_recommend_shop if recommend.recommend_result.nil?

    shops = recommend.recommend_result[:shops]
    conditions = recommend.recommend_result[:conditions]

    # WIP: [create recommend conversation]
    recommend_conversation_repository.create(recommend_transaction_id: transaction[:id], conditions: conditions.to_json, user_word: @user_message, bot_word: reply_message_text)

    @reply_message << render_shops_template(shops).merge(get_more_condition)
  end

  # 友達追加時に実行
  def register_thanks_reply
    @reply_message << {
      type: 'text',
      text: '友達登録ありがとうにゃ！'
    }
  end

  # ユーザーIDを取得できなかった時
  def cannot_get_user_id
    reset_reply_message
    @reply_message << {
      type: 'text',
      text: 'ユーザー情報を取得できなかったにゃ……。一度ブロックして、もう一回追加して欲しいにゃ。'
    }
    send_message(@events.first)
  end

  def get_more_condition
    lists = []
    more_conditions = ConditionRepository.new.more_conditions
    lists = more_conditions.values
    more_items = more_condition_items.select { |item| lists.include?(item[:label]) }
    more_items.empty? ? {} : create_quick_reply(more_items)
  end

  # Quickメッセージを作成
  def create_quick_reply(item_list)
    items = []
    item_list.each do |item|
      items << {
        type: 'action',
        imageUrl: item[:imageUrl],
        action: {
          type: item[:type],
          label: item[:label],
          text: item[:text].blank? ? item[:label] : item[:text]
        }
      }
    end
    {
      quickReply: {
        items: items
      }
    }
  end

  def cannot_found_recommend_shop
    reset_reply_message
    @reply_message << {
      type: 'text',
      text: '近くにお店が見当たらなかったにゃ……'
    }
  end

  private

  def render_shops_template(shops)
    columns = []
    if shops.blank?
      cannot_found_recommend_shop
    else
      shops.each do |shop|
        columns << {
          thumbnailImageUrl: shop['photo']['pc']['l'],
          title: shop['name'],
          text: shop['catch'],
          actions: [
            {
              type: 'message',
              label: 'ここにする',
              text: 'ここにする'
            },
            {
              type: 'uri',
              label: '詳しくみる',
              uri: shop['urls']['pc']
            }
          ]
        }
      end
    end

    {
      type: 'template',
      altText: 'オススメのお店',
      template: {
        type: 'carousel',
        columns: columns
      }
    }
  end

  def more_condition_items
    [
      {
        label: 'もっと安い',
        imageUrl: 'https://2.bp.blogspot.com/-6eX4a0aKzH0/UVTVHAV0-DI/AAAAAAAAPCc/JP2uDFtSvqk/s400/saifu_gamaguchi.png',
        type: 'message'
      },
      {
        label: 'もっと高い',
        imageUrl: 'https://2.bp.blogspot.com/-oDwavrWTeeo/WAhy4ctz82I/AAAAAAAA_IY/TYSatkgb5jcXa9vf1LeH2Ehdd5tI-2nQwCLcB/s400/tabako_suigara.png',
        type: 'message'
      },
      {
        label: 'もっと近く',
        imageUrl: 'https://2.bp.blogspot.com/-6eX4a0aKzH0/UVTVHAV0-DI/AAAAAAAAPCc/JP2uDFtSvqk/s400/saifu_gamaguchi.png',
        type: 'message'
      },
      {
        label: 'もっと遠く',
        imageUrl: 'https://2.bp.blogspot.com/-oDwavrWTeeo/WAhy4ctz82I/AAAAAAAA_IY/TYSatkgb5jcXa9vf1LeH2Ehdd5tI-2nQwCLcB/s400/tabako_suigara.png',
        type: 'message'
      },
      {
        label: '喫煙可',
        imageUrl: 'https://2.bp.blogspot.com/-oDwavrWTeeo/WAhy4ctz82I/AAAAAAAA_IY/TYSatkgb5jcXa9vf1LeH2Ehdd5tI-2nQwCLcB/s400/tabako_suigara.png',
        type: 'message'
      },
      {
        label: '禁煙',
        imageUrl: 'https://2.bp.blogspot.com/-oDwavrWTeeo/WAhy4ctz82I/AAAAAAAA_IY/TYSatkgb5jcXa9vf1LeH2Ehdd5tI-2nQwCLcB/s400/tabako_suigara.png',
        type: 'message'
      },
      {
        label: '近くのお店',
        type: 'location'
      }
    ]
  end
end
