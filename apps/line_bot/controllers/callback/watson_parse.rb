# genericのみを返す
def get_generic(result)
  result['output'].empty? || result['output']['generic'].empty? ? nil : result['output']['generic']
end

# intentsを返す
def get_intents(result)
  result['output'].empty? || result['output']['intents'].empty? ? nil : result['output']['intents']
end

# entitiesを返す
def get_entities(result)
  result['output'].empty? || result['output']['entities'].empty? ? nil : result['output']['entities']
end

# entitiesに含まれているentityを配列で取得
def pull_entities(entities)
  return if entities.blank?

  result = []
  entities.each do |entity|
    result << entity['entity']
  end
  result
end

# 返信用のテキスト文を取得
def get_reply_text(result)
  # binding.pry
  return if result['output'].empty? || result['output']['generic'].empty?

  result['output']['generic'].first['text'] if result['output']['generic'].first['response_type'] == 'text'
end

# watsonのentityに引っかかったオリジナルのワードを取得
def get_origin_entities(origin_text, watson_result, entity_key = nil)
  result = []
  get_entities(watson_result).each do |entity|
    result << origin_text[entity['location'][0], entity['location'][1]] if !entity_key.blank? && entity['entity'] === entity_key || entity_key.blank?
  end
  result
end
