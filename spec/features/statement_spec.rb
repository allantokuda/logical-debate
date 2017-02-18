require 'spec_helper'

describe 'Statement' do
  let(:user) { FactoryGirl.create(:user) }
  let(:statement) { FactoryGirl.create :statement, top_level: true }
  let!(:argument1) { FactoryGirl.create :argument, :published, subject_statement: statement, agree: true, text: 'This is a good argument.' }
  let!(:argument2) { FactoryGirl.create :argument, :published, subject_statement: statement, agree: false, text: 'This is a bad argument.' }

  before do
    visit '/'
    login_as user, scope: :user
  end

  describe 'form' do
    before(:each) do
      visit new_statement_path
    end

    it 'errors if more than one sentence is entered' do
      find('input.statement-line').set('This is great. So great.')
      click_button 'Publish'
      expect(find('.errors', text: 'Please verify that this is only one sentence.'))
    end

    it 'allows the user to override the multiple sentence detector' do
      find('input.statement-line').set('This. is. a. sentence. with. stylistic. periods.')
      check 'This is one sentence.'
      click_button 'Publish'
      expect(find('.statement-heading', text: 'This. is. a. sentence. with. stylistic. periods.')).to be_present
    end
  end

  context 'that has been posted' do
    before do
      visit statement_path(statement.id)
      expect(find('.statement-heading', text: statement.text)).to be_present
    end

    it 'can be agreed with, picking existing arguments to support' do
      click_button 'Agree'
      find('label', text: 'This is a good argument').click
      click_button 'Next'
      expect(Vote.find_by(user: user, argument: argument1)).to be_present
      expect(Vote.find_by(user: user, argument: argument2)).to_not be_present

      # Modest user removes own auto-upvote
      find('div.argument', text: 'This is a good argument').click_button 'Remove upvote'
      expect(Vote.find_by(user: user, argument: argument1)).to_not be_present
    end

    it 'can be disagreed with, picking existing counterarguments to support' do
      click_button 'Disagree'
      find('label', text: 'This is a bad argument').click
      click_button 'Next'
      expect(Vote.find_by(user: user, argument: argument2)).to be_present
      expect(Vote.find_by(user: user, argument: argument1)).to_not be_present

      # Modest user removes own auto-upvote
      find('div.argument', text: 'This is a bad argument').click_button 'Remove upvote'
      expect(Vote.find_by(user: user, argument: argument2)).to_not be_present
    end
  end
end
