require 'spec_helper'

describe 'Statement' do
  let(:user) { FactoryGirl.create(:user) }
  let(:statement) { FactoryGirl.create :statement, top_level: true }
  let(:argument1) { FactoryGirl.create :argument, :published, subject_statement: statement, agree: true }
  let(:argument2) { FactoryGirl.create :argument, :published, subject_statement: statement, agree: false }
  let!(:premise1) { FactoryGirl.create :premise, argument: argument1, statement: FactoryGirl.create(:statement, text: 'This is a good argument.') }
  let!(:premise2) { FactoryGirl.create :premise, argument: argument2, statement: FactoryGirl.create(:statement, text: 'This is a bad argument.') }

  before(:each) do
    visit '/'
    login_as user, scope: :user
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
    find('div.argument', text: 'This is a good argument').click_button 'Remove vote'
    expect(Vote.find_by(user: user, argument: argument1)).to_not be_present
  end

  it 'can be disagreed with, picking existing counterarguments to support' do
    click_button 'Disagree'
    find('label', text: 'This is a bad argument').click
    click_button 'Next'
    expect(Vote.find_by(user: user, argument: argument2)).to be_present
    expect(Vote.find_by(user: user, argument: argument1)).to_not be_present

    # Modest user removes own auto-upvote
    find('div.argument', text: 'This is a bad argument').click_button 'Remove vote'
    expect(Vote.find_by(user: user, argument: argument2)).to_not be_present
  end
end
