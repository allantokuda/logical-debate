require 'spec_helper'

describe 'Statement' do
  describe 'before validation' do
    it 'trims whitespace' do
      (s = Statement.new(text: '  This is a sentence.   ')).valid?
      expect(s.text).to eq       'This is a sentence.'
    end

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

  describe 'stance of user' do
    it 'returns nil for unrelated statement and user' do
      user = User.new
      statement = Statement.new
      result = statement.stance_of(user)
      expect(result).to be_nil
    end

    it 'returns a stance of agree=true for the current user' do
      user = User.new
      statement = Statement.new(user: user)
      result = statement.stance_of(user)
      expect(result).to be_a(Stance)
      expect(result.agree).to be true
    end

    it 'returns a stance linking the statement and user' do
      statement = FactoryGirl.create :statement
      user1 = FactoryGirl.create :user
      user2 = FactoryGirl.create :user
      stance1 = FactoryGirl.create :stance, statement: statement, user: user1, agree: true
      stance2 = FactoryGirl.create :stance, statement: statement, user: user2, agree: false
      result1 = statement.stance_of(user1)
      result2 = statement.stance_of(user2)
      expect(result1).to eq stance1
      expect(result2).to eq stance2
    end
  end
end
