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
    @@fallacies[(name.presence || '').downcase] || Fallacy.new
  end

  def self.common
    @@common_fallacies
  end

  attr_accessor :names, :description, :common_index, :formal, :fill_in

  def initialize(fallacy_data = {})
    @names        = fallacy_data['names'] || []
    @description  = fallacy_data['description']
    @common_index = fallacy_data['common_index']
    @formal       = fallacy_data['formal']
    @fill_in      = fallacy_data['fill_in']
  end

  def name
    names.first
  end

  def fill_in_structure
    "#{name}: #{fill_in || description}".scan(/\[[^\[\]]+\]|[^\[\]]+/).map do |part|
      {
        highlight: part[0] == '[',
        text: part.delete('[').delete(']')
      }
    end
  end

  def as_statement
    "#{name}: #{description}"
  end
end

Fallacy.load_all
