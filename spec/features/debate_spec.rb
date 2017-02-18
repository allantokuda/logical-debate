require 'spec_helper'

describe 'Debate' do
  let(:user1) { FactoryGirl.create(:user, username: 'Allan') }
  let(:user2) { FactoryGirl.create(:user, username: 'Bobby') }
  let(:user3) { FactoryGirl.create(:user, username: 'Corey') }
  let(:statement) { FactoryGirl.create :statement, top_level: true }
  let!(:argument1) { FactoryGirl.create :argument, :published, subject_statement: statement, agree: true, user: user1 }
  let!(:argument2) { FactoryGirl.create :argument, :published, subject_statement: statement, agree: false, user: user3 }

  before(:each) do
    visit '/'
    login_as user2, scope: :user
    visit statement_path(statement.id)
  end

  it "allows a user to challenge another user's argument" do
    click_button 'Disagree'
    click_button 'Next'
    click_link 'Counter'
    find('label', text: 'Irritating').click
    click_button 'Next'
    click_button 'Publish'
    expect(find('.statement-heading', text: 'intended to be a nuisance')).to be_present
    expect(find('.breadcrumbs', text: argument1.text)).to be_present
  end

  # Hidden feature for now - needs redesign before release.
  it "allows a user to improve on another user's argument" do
    click_button 'Agree'
    click_button 'Next'
    click_link(argument1.text)
    click_link 'Clarify'

    fill_in 'argument[text]', with: 'A clearer version of what was already said.'

    click_button 'Save'
    expect(argument1.reload.child_arguments).to be_present
    expect(find('.argument-explanation', text: "clarification")).to be_present
    expect(find('.statement-heading', text: "A clearer version of what was already said.")).to be_present
  end

  it 'can navigate between arguments children/parents' do
    child_argument = FactoryGirl.create :argument, parent_argument: argument1, user: user2
    visit argument_path(child_argument)
    click_link "Back to parent argument"
    click_link "Bobby's clarification"
  end
end
