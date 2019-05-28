

def getQuickReplyTest
  message = {
    type: "text",
    text: "こんばんは。今日の夜ご飯はどうしますか？",
    quickReply: {
      items: [
        {
          type: "action",
          imageUrl: "https://2.bp.blogspot.com/-RB1mDuQvGkI/USyJ0W9QfKI/AAAAAAAAObc/Idip0N8CFUw/s550/nigirizushi_moriawase.png",
          action: {
            type: "message",
            label: "お寿司",
            text: "お寿司"
          }
        },
        {
          type: "action",
          imageUrl: "https://2.bp.blogspot.com/-qoxECGunNzE/UvTeJLrLZ3I/AAAAAAAAdkU/Bdwv6FR0Mi8/s400/food_tenpura.png",
          action: {
            type: "message",
            label: "天ぷら",
            text: "天ぷら"
          }
        },
        {
          type: "action",
          action: {
            type: "location",
            label: "周辺のご飯を探す"
          }
        }
      ]
    }
  }
  return message
end

def getTextReplyTest
  message = {
    type: "text",
    text: "test"
  }
  return message
end

def getCalucelReplyTest
  message = {
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
            },
          ],
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
            },
          ],
        },
      ]
    }
  }
  return message
end

def parseCalucelMessage(columns)
  if columns.length > 0 then
    return {
      type: 'template',
      altText: 'this is an template message',
      template: {
        type: 'carousel',
        columns: columns
      }
    }
  else
    return {
      type: 'text',
      text: 'データが見つかりません'
    }
  end
end

def getRecommendSample(word)
  shops = RecommendShop.new.call(1, word.split(','))

  Hanami.logger.debug shops.shops.to_json

  columns = []
  shops.shops.each do |shop|
    columns << {
      thumbnailImageUrl: shop['photo']['pc']['l'],
      title: shop['name'],
      text: shop['catch'],
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
        },
      ],
    }
  end

  message = {
    type: 'template',
    altText: 'this is an template message',
    template: {
      type: 'carousel',
      columns: columns
    }
  }
  return message
end
