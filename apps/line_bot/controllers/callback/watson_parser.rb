require 'ibm_watson/assistant_v2'

class WatsonParser
  attr_reader :result

  def assistant
    @assistant = IBMWatson::AssistantV2.new(
      version: '2018-09-17',
      username: ENV['WATSON_USERNAME'],
      password: ENV['WATSON_PASSWORD']
    )
  end

  def initialize(session = nil)
    @session = session.nil? ? assistant.create_session(
      assistant_id: ENV['WATSON_ASSISTANT_ID']
    ) : session
  end

  def create_new_session
    @session = assistant.create_session(
      assistant_id: ENV['WATSON_ASSISTANT_ID']
    )
  end

  # Watsonにリクエストを投げる
  def requestAnalysis(text)
    @result = request({ text: text }).result
  end

  def generic
    @result['output'].empty? || @result['output']['generic'].empty? ? nil : @result['output']['generic']
  end
  
  # intentsを返す
  def intents
    @result['output'].empty? || @result['output']['intents'].empty? ? nil : @result['output']['intents']
  end
  
  # entitiesを返す
  def entities
    @result['output'].empty? || @result['output']['entities'].empty? ? nil : @result['output']['entities']
  end

  # entitiesに含まれているentityを配列で取得
  def pull_entities
    return if entities.blank?

    entity_list = []
    entities.each do |entity|
      entity_list.push(entity['entity'])
    end
    entity_list
  end

  # 返信用のテキスト文を取得
  def reply_text
    return if @result['output'].empty? || @result['output']['generic'].empty?

    @result['output']['generic'].first['text'] if @result['output']['generic'].first['response_type'] == 'text'
  end

  # watsonのentityに引っかかったオリジナルのワードを取得
  def get_origin_entities(origin_text, entity_key = nil)
    result = []
    entities.each do |entity|
      result.push(origin_text[entity['location'][0], entity['location'][1]]) if !entity_key.blank? && entity['entity'] === entity_key || entity_key.blank?
    end
    result
  end

  private

  def request(input)
    assistant.message(
      assistant_id: ENV['WATSON_ASSISTANT_ID'],
      session_id: @session.result['session_id'],
      input: input
    )
  end

end
