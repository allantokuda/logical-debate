require 'spec_helper'

describe 'Debate' do
  let(:user1) { FactoryGirl.create(:user, username: 'Allan') }
  let(:user2) { FactoryGirl.create(:user, username: 'Bobby') }
  let(:argument) { FactoryGirl.create :argument, user: user1, published_at: Time.zone.now }
  let!(:premise) { FactoryGirl.create :premise, argument: argument }

  before(:each) do
    visit '/'
    login_as user2, scope: :user
    visit argument_path(argument.id)
  end

  it "allows a user to challenge another user's argument" do
    click_link 'Counter'
    fill_in 'statement_text', with: 'This is a straw man argument. You misrepresented their argument to make it easier to attack.'
    click_button 'Publish'
    expect(find('.statement-heading', text: 'This is a straw man argument')).to be_present
    expect(find('.countered-argument', text: argument.one_line)).to be_present
  end

  it "allows a user to improve on another user's argument" do
    click_link 'Clarify'
    # TODO: indicate disagreement, make edits
    click_button 'Save'
    expect(argument.reload.child_arguments).to be_present
    expect(find('.argument-explanation', text: "You interpret Allan's argument as follows")).to be_present
  end

  it 'can navigate between arguments children/parents' do
    child_argument = FactoryGirl.create :argument, parent_argument: argument, user: user2
    visit argument_path(child_argument)
    click_link "Allan's argument"
    click_link "Bobby's reply"
  end
end
