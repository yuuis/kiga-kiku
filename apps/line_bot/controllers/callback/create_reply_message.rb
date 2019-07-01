require_relative 'watson_parse'
require 'line/bot'

class CreateReplyMessage < LineManager
  
  def initialize(body)
    super
    @reply_message = []
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
    # get_recommend
    return if @watson_result.blank?

    words = get_origin_entities(@user_message, @watson_result, 'メニュー') # watsonのメニューに引っかかった

    location = LocationRepository.new.latest(get_user_id(@line_event))
    latitude, longitude = location.latitude, location.longitude unless location.nil?
    
    shops = RecommendShop.new.call(user_id = get_user_id(line_event), words = words, latitude = latitude, longitude = longitude)
    render_shops_template(shops)
  end
  
  # リプライメッセージを初期化
  def reset_reply_message
    @reply_message = []
  end


  # 友達追加時に実行
  def set_register_thanks
    @reply_message << {
      type: 'text',
      text: '友達登録ありがとうにゃ！'
    }
  end

  def send_message(event)
    client.reply_message(event['replyToken'], @reply_message)
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


end
