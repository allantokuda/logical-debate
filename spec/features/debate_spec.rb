require 'spec_helper'

describe 'Debate' do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:argument) { FactoryGirl.create :argument, user: user2, published_at: Time.zone.now }

  before(:each) do
    visit '/'
    login_as user1, scope: :user
    visit argument_path(argument.id)
  end

  it "allows a user to challenge another user's argument" do
    click_link 'Reply'
    # TODO: indicate agreement, make edits
    click_button 'Save'
    expect(argument.reload.child_arguments).to be_present
  end

  it "allows a user to improve on another user's argument" do
    click_link 'Reply'
    # TODO: indicate disagreement, make edits
    click_button 'Save'
    expect(argument.reload.child_arguments).to be_present
  end
end
