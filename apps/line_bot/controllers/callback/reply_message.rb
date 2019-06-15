require_relative 'watson_parse'

def get_message(line_event, watson_reply) 

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

  user_id = 1 # TODO:line_idからuser_idを抽出

  # 引っかかったキーワードを取得してみる
  words = get_origin_entities(line_event.message['text'], watson_reply)

  shops = RecommendShop.new.call(user_id, ["ラーメン"])

  columns = []
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
