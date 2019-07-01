require_relative 'watson_parse'
require_relative 'line_manager'
require 'line/bot'

class CreateReplyMessage < LineManager
  
  def initialize(body)
    super
    @reply_message = []
  end

  # リプライメッセージを初期化
  def reset_reply_message
    @reply_message = []
  end

  def send_message(event)
    client.reply_message(event['replyToken'], @reply_message)
  end


  # Watsonからの応答をもらう
  def set_watson_result(watson_result)
    @watson_result = watson_result
  end
  
  # Watsonのテキストリプライを設定
  def set_watson_text_reply
    @reply_message << {
      type: 'text',
      text: get_reply_text(@watson_result)
    } unless @watson_result.blank?
  end

  # レコメンド実行
  def set_recommend_shop
    return if @watson_result.blank?

    set_watson_text_reply # ワトソンの応答応答を送る

    watson_entities = pull_entities(get_entities(@watson_result)) 

    # WIP: Recommend Transaction
    # transaction = RecommendTransactionRepository.new.find_by_user_id(user_id: get_user_id)

    if watson_entities.include?('精度向上キーワード')
      words = ['ラーメン'] # 前回のワードを取得

      user_request = 'もっと安い' # ユーザが送ってきた要望「もっと**」
      past_conditions = ConditionRepository.new.condition_checks(user_request, nil) #WIP: conditionを取得して格納

    elsif watson_entities.include?('メニュー')
      words = get_origin_entities(@user_message, @watson_result, 'メニュー') # watsonのメニューに引っかかった
    elsif watson_entities.include?('起動ワード')
      # WIP: 時間によって変更
      words = ['ラーメン']
    end

    location = LocationRepository.new.latest(get_user_id)
    latitude, longitude = location.latitude, location.longitude unless location.nil?
    
    shops = RecommendShop.new.call(user_id = get_user_id, words = words, latitude = latitude, longitude = longitude, past_conditions = past_conditions )
    @reply_message << render_shops_template(shops).merge(get_more_condition)
  end
  
  # 友達追加時に実行
  def set_register_thanks
    @reply_message << {
      type: 'text',
      text: '友達登録ありがとうにゃ！'
    }
  end

  def get_more_condition
    lists = []
    more_conditions = ConditionRepository.new.more_conditions
    lists = more_conditions.find {|key, value| value }
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


  private
  def render_shops_template(shops)
    columns = []
    if shops.shops.blank?
      reset_reply_message()
	    return {
	      type: 'text',
	      text: '近くにお店が見当たらなかったにゃ……'
	    }
	  else
      shops.shops.each do |shop|
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
