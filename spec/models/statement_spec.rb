require 'spec_helper'

describe 'Statement' do
  describe 'before validation' do
    it 'automatically adds a period at the end if there is no punctuation' do
      (s = Statement.new(text: 'This is bad grammar')).valid?
      expect(s.text).to eq     'This is bad grammar.' # added period
    end

    it 'leaves text as-is if already ending in a period' do
      (s = Statement.new(text: 'This is a sentence.')).valid?
      expect(s.text).to eq     'This is a sentence.'
    end

    it 'leaves text as-is if already ending in a bang' do
      (s = Statement.new(text: 'This is an exclamation!')).valid?
      expect(s.text).to eq     'This is an exclamation!'
    end

    it 'leaves text as-is if a question' do
      (s = Statement.new(text: 'This is a question?')).valid?
      expect(s.text).to eq     'This is a question?'
    end
  end
end
