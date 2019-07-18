require_relative 'line_manager'
require 'line/bot'

class CreateReplyMessage < LineManager
  attr_accessor :user_message

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

  # Watsonクラスのオブジェクトをコピー
  def register_watson(watson)
    @watson = watson
  end

  # Watsonのテキストリプライを設定
  def watson_text_reply
    unless @watson.result.blank?
      @reply_message.push(
        type: 'text',
        text: @watson.reply_text
      )
    end
  end

  # レコメンド実行
  def recommend_shop
    return if @watson.result.blank?

    transaction = get_transaction(user_id)
    conversation = RecommendConversationRepository.new.find_by_transaction(transaction) unless transaction.nil?

    watson_text_reply
    watson_entities = @watson.pull_entities

    words = []
    shop_ids = []

    # 「もっと~」
    if watson_entities.include?('精度向上キーワード') && !conversation.nil?
      user_request = @watson.get_origin_entities(user_message).first
      pre_conditions = JSON.parse(conversation.conditions, symbolize_names: true)
      past_conditions = check_conditions(user_request, pre_conditions)

      conversations = RecommendConversationRepository.new.find_all_by_transaction(transaction)
      conversation = conversations[conversations.size - 2]
      shop_ids = RecommendedShopRepository.new.find_by_conversation(conversation).map { |shop| shop.shop_id }

    # watsonのメニューに引っかかったワード
    elsif watson_entities.include?('メニュー')
      words = @watson.get_origin_entities(@user_message, 'メニュー')
    end

    location = latest_location(user_id)

    recommend = RecommendShop.new.call(user_id, words, location[:latitude], location[:longitude], past_conditions)
    shops = recommend.recommend_result[:shops].delete_if do |shop|
      shop_ids.include?(shop['id'])
    end
    # shops = recommend.recommend_result[:shops]
    conditions = recommend.recommend_result[:conditions]

    return cannot_found_recommend_shop if shops.empty?

    conversation = RecommendConversationRepository.new.create(recommend_transaction_id: transaction[:id], conditions: conditions.to_json, user_word: @user_message, bot_word: reply_message_text)

    shop_repository = RecommendedShopRepository.new
    shops.each do |shop|
      shop_repository.create(shop_id: shop['id'], recommend_conversation_id: conversation.id)
    end
    @reply_message.push(render_shops_template(shops).merge(get_more_condition))
  end

  # 友達追加時に実行
  def register_thanks_reply
    @reply_message.push(
      type: 'text',
      text: '友達登録ありがとうにゃ！'
    )
  end

  # ユーザーIDを取得できなかった時
  def cannot_get_user_id
    reset_reply_message
    @reply_message.push(
      type: 'text',
      text: 'ユーザー情報を取得できなかったにゃ……。一度ブロックして、もう一回追加して欲しいにゃ。'
    )
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
      items.push(
        type: 'action',
        imageUrl: item[:imageUrl],
        action: {
          type: item[:type],
          label: item[:label],
          text: item[:text].blank? ? item[:label] : item[:text]
        }
      )
    end
    {
      quickReply: {
        items: items
      }
    }
  end

  def cannot_found_recommend_shop
    reset_reply_message
    @reply_message.push(
      type: 'text',
      text: '近くにお店が見当たらなかったにゃ……'
    )
  end

  private

  def get_transaction(user_id)
    transaction_repository = RecommendTransactionRepository.new

    transaction = transaction_repository.find_by_user_id(user_id)
    return transaction_repository.create(user_id: user_id).to_h if transaction.nil?

    transaction
  end

  def latest_location(user_id)
    location = LocationRepository.new.latest(user_id)
    unless location.nil?
      latitude = location.latitude
      longitude = location.longitude
    end

    { latitude: latitude, longitude: longitude }
  end

  def check_conditions(word, conditions)
    condition_repository = ConditionRepository.new
    more_conditions = condition_repository.more_conditions
    case word
    when more_conditions[:cheaper] then condition_repository.cheaper(conditions)
    when more_conditions[:more_expensive] then condition_repository.more_expensive(conditions)
    when more_conditions[:closer] then condition_repository.closer(conditions)
    when more_conditions[:farther] then condition_repository.farther(conditions)
    end
  end

  def render_shops_template(shops)
    columns = []
    if shops.blank?
      cannot_found_recommend_shop
    else
      shops.each do |shop|
        columns.push(
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
        )
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
        imageUrl: 'https://2.bp.blogspot.com/-qJ2zpEvwEyk/Vx9UtcxS4sI/AAAAAAAA6D0/PZ5P7j37bjI0mQcCPNaxAQ-TAe5Zy7thACLcB/s800/money_fueru.png',
        type: 'message'
      },
      {
        label: 'もっと近い',
        imageUrl: 'https://4.bp.blogspot.com/-vOwPLozE1eo/V5jHiG1EuwI/AAAAAAAA80g/4JxL0zU2EN4mpavZ9QCtLS_IZ8siEJ8yACLcB/s800/walking2_man.png',
        type: 'message'
      },
      {
        label: 'もっと遠い',
        imageUrl: 'https://3.bp.blogspot.com/-gnzOpz-Nh1k/WCqdq_V3EfI/AAAAAAAA_lM/_krYEmqW0asvm5H4HD9rctUjZqTSxHcYACLcB/s800/car_animals.png',
        type: 'message'
      },
      {
        label: '喫煙できる',
        imageUrl: 'https://2.bp.blogspot.com/-oDwavrWTeeo/WAhy4ctz82I/AAAAAAAA_IY/TYSatkgb5jcXa9vf1LeH2Ehdd5tI-2nQwCLcB/s400/tabako_suigara.png',
        type: 'message'
      },
      {
        label: '禁煙',
        imageUrl: 'https://2.bp.blogspot.com/-oDwavrWTeeo/WAhy4ctz82I/AAAAAAAA_IY/TYSatkgb5jcXa9vf1LeH2Ehdd5tI-2nQwCLcB/s400/tabako_suigara.png',
        type: 'message'
      },
      {
        label: '現在地を教える',
        type: 'location'
      }
    ]
  end
end
