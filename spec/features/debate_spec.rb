require 'spec_helper'

describe 'Debate' do
  let(:user1) { FactoryGirl.create(:user, username: 'Allan') }
  let(:user2) { FactoryGirl.create(:user, username: 'Bobby') }
  let(:user3) { FactoryGirl.create(:user, username: 'Corey') }
  let(:statement) { FactoryGirl.create :statement, top_level: true }
  let(:argument1) { FactoryGirl.create :argument, :published, subject_statement: statement, agree: true, user: user1 }
  let(:argument2) { FactoryGirl.create :argument, :published, subject_statement: statement, agree: false, user: user3 }
  let!(:premise1) { FactoryGirl.create :premise, argument: argument1 }
  let!(:premise2) { FactoryGirl.create :premise, argument: argument2 }

  before(:each) do
    visit '/'
    login_as user2, scope: :user
    visit statement_path(statement.id)
  end

  it "allows a user to challenge another user's argument" do
    click_button 'Disagree'
    click_button 'Next'
    click_link 'Counter'
    fill_in 'statement_text', with: 'This is a straw man argument. You misrepresented their argument to make it easier to attack.'
    click_button 'Publish'
    expect(find('.statement-heading', text: 'This is a straw man argument')).to be_present
    expect(find('.countered-argument', text: argument1.one_line)).to be_present
  end

  it "allows a user to improve on another user's argument" do
    click_button 'Agree'
    click_button 'Next'
    click_link premise1.text
    click_link 'Clarify'

    # add a premise
    all('input.statement-line', minimum: 2)[-1].set('New premise 1')

    # add another premise
    click_button 'Add another premise'
    all('input.statement-line', minimum: 2)[-1].set('New premise 2')

    click_button 'Save'
    expect(argument1.reload.child_arguments).to be_present
    expect(find('.argument-explanation', text: "You interpret Allan's argument as follows")).to be_present
    expect(find('.premises-list li', text: "New premise 1")).to be_present
    expect(find('.premises-list li', text: "New premise 2")).to be_present
  end

  it 'can navigate between arguments children/parents' do
    child_argument = FactoryGirl.create :argument, parent_argument: argument1, user: user2
    visit argument_path(child_argument)
    click_link "Allan's argument"
    click_link "Bobby's reply"
  end
end
