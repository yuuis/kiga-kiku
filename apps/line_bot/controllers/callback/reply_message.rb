require_relative 'watson_parse'

def get_user_id(line_event)
  line_user_id = line_event['source']['userId']

  user_rel = UserLineUserRelRepository.new.find_by_line_user_id(line_user_id: line_user_id)
  user_id = user_rel.blank? ? nil : user_rel.user_id
end

def get_message(_line_event, watson_reply)
  # line_id = event.message['id']

  # TODO: line_idをuser_idに変換

  # Watson_replyを使って返信テキストを取得
  reply_text = get_reply_text(watson_reply)
  {
    type: 'text',
    text: reply_text
  }
end

def get_recommend(line_event, watson_reply)
  # 引っかかったキーワードを取得してみる
  words = get_origin_entities(line_event.message['text'], watson_reply, 'メニュー')

  location = LocationRepository.new.latest(get_user_id(line_event))
  latitude, longitude = location.latitude, location.longitude unless location.nil?

  shops = RecommendShop.new.call(user_id = get_user_id(line_event), words = words, latitude = latitude, longitude = longitude)

  render_shops_template(shops)
end

# 特にワード指定無しでレコメンド
def get_first_recommend(line_event)
  location = LocationRepository.new.latest(get_user_id(line_event))
  latitude, longitude = location.latitude, location.longitude unless location.nil?

  shops = RecommendShop.new.call(user_id = get_user_id(line_event), words = ['ラーメン'], latitude = latitude, longitude = longitude)

  render_shops_template(shops)
end

def get_quick_reply(items_list)
  more_items = RECOMMEND_MORE_ITEMS.select { |item| items_list.include?(item[:label]) }
  more_items.empty? ? {} : quick_reply(more_items)
end

def quick_reply(items_list)
  items = []
  items_list.each do |item|
    items << {
      type: 'action',
      imageUrl: item[:imageUrl].blank? ? nil : item[:imageUrl],
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

RECOMMEND_MORE_ITEMS = [
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
].freeze
RECOMMEND_MORE_ITEMS.freeze

private
def render_shops_template(shops)
  columns = []
  if shops.shops.blank?
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

def get_add_friend
  {
    type: 'text',
    text: '友達登録ありがとうにゃ！'
  }
end
