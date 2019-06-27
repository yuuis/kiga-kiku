def get_quick_reply_test
  {
    type: 'text',
    text: 'こんばんは。今日の夜ご飯はどうしますか？',
    quickReply: {
      items: [
        {
          type: 'action',
          imageUrl: 'https://2.bp.blogspot.com/-RB1mDuQvGkI/USyJ0W9QfKI/AAAAAAAAObc/Idip0N8CFUw/s550/nigirizushi_moriawase.png',
          action: {
            type: 'message',
            label: 'お寿司',
            text: 'お寿司'
          }
        },
        {
          type: 'action',
          imageUrl: 'https://2.bp.blogspot.com/-qoxECGunNzE/UvTeJLrLZ3I/AAAAAAAAdkU/Bdwv6FR0Mi8/s400/food_tenpura.png',
          action: {
            type: 'message',
            label: '天ぷら',
            text: '天ぷら'
          }
        },
        {
          type: 'action',
          action: {
            type: 'location',
            label: '周辺のご飯を探す'
          }
        }
      ]
    }
  }
end

def get_text_reply_test
  {
    type: 'text',
    text: 'test'
  }
end

def get_carousel_reply_test
  {
    type: 'template',
    altText: 'this is an template message',
    template: {
      type: 'carousel',
      columns: [
        {
          thumbnailImageUrl: 'https://example.com/image1.jpg',
          title: 'example',
          text: 'test',
          actions: [
            {
              type: 'message',
              label: 'keep',
              text: 'keep'
            },
            {
              type: 'uri',
              label: 'site',
              uri: 'https://example.com/page1'
            }
          ]
        },
        {
          thumbnailImageUrl: 'https://example.com/image2.jpg',
          title: 'example',
          text: 'test',
          actions: [
            {
              type: 'message',
              label: 'keep',
              text: 'keep'
            },
            {
              type: 'uri',
              label: 'site',
              uri: 'https://example.com/page2'
            }
          ]
        }
      ]
    }
  }
end

def get_datepicker_test
  {
    type: 'template',
    altText: 'this is an template message',
    template: {
      type: 'buttons',
      title: 'event schedule',
      text: 'select date',
      actions: [
        {
          type: 'datetimepicker',
          label: 'ok',
          data: 'datetimepicker=ok',
          mode: 'date'
        },
        {
          type: 'postback',
          label: 'no',
          data: 'datetimepicker=no'
        }
      ]
    }
  }
end

def parse_carousel_message(columns)
  if columns.empty?
    {
      type: 'text',
      text: 'データが見つかりません'
    }
  else
    {
      type: 'template',
      altText: 'this is an template message',
      template: {
        type: 'carousel',
        columns: columns
      }
    }
  end
end

def get_recommend_sample(userid, word)
  location = LocationRepository.new.find(user_id: params.get(:user_id))
  latitude, longitude = location.latitude, location.longitude unless location.nil?

  shops = RecommendShop.new.call(user_id = userid, words = word.split(/[,\n*| ]/), latitude = latitude, longitude = longitude)

  Hanami.logger.debug word.split(/[,\n*| ]/)

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
    altText: 'this is an template message',
    template: {
      type: 'carousel',
      columns: columns
    }
  }
end
