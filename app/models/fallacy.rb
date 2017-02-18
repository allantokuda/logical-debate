class Fallacy
  FILE_NAME = Rails.env.test? ? 'fallacies_test.yml' : 'fallacies.yml'
  FILE_PATH = "#{Rails.root}/config/#{FILE_NAME}"

  def self.load_all
    @@fallacies = {}
    @@common_fallacies = []
    YAML.load_file(FILE_PATH).each do |fallacy|
      fallacy = self.new(fallacy)
      fallacy.names.each do |name|
        @@fallacies[name.downcase] = fallacy
      end
      @@common_fallacies << fallacy if fallacy.common_index.present?
    end
    @@common_fallacies.sort_by! { |f| f.common_index }
  end

  def self.all
    @@fallacies.values
  end

  def self.find_by_name(name)
    @@fallacies[(name.presence || '').downcase] || UndefinedFallacy.new
  end

  def self.common
    @@common_fallacies
  end

  attr_accessor :names, :description, :common_index, :formal, :questions

  def initialize(fallacy_data = {})
    @names        = fallacy_data['names'] || []
    @description  = fallacy_data['description']
    @common_index = fallacy_data['common_index']
    @formal       = fallacy_data['formal']
    @fill_in      = fallacy_data['fill_in']
    @questions    = (fallacy_data['questions'] || []).map { |q| Question.new(q) }
  end

  def name
    names.first
  end

  def fill_in
    @fill_in || description || ''
  end

  def filled_in(response_params)
    result = fill_in.dup
    @questions.each do |question|
      result.gsub!("[#{question.name}]", response_params[question.name].to_s || '___')
    end
    result
  end

  def as_statement
    "#{name}: #{description}"
  end

  def defined?
    true
  end

  class UndefinedFallacy < Fallacy
    def defined?
      false
    end
  end
end

Fallacy.load_all
