require 'spec_helper'

describe 'An argument' do
  let(:statement) { FactoryGirl.create :statement }

  before(:each) do
    visit statement_path(statement.id)
    expect(find('.statement-heading', text: statement.text)).to be_present
  end

  it 'can agree with a statement' do
    click_link 'Agree'
    expect(find('.argument-heading', text: "User agrees with: #{statement.text}")).to be_present

    fill_in 'new_premise', with: 'Honesty is unprofitable.'
    click_button 'Save'
    expect(find('.premises-list li', text: 'Honesty is unprofitable.')).to be_present
    expect(statement.arguments).to be_present
  end

  it 'can disagree with a statement' do
    click_link 'Disagree'
    expect(find('.argument-heading', text: "User disagrees with: #{statement.text}")).to be_present

    fill_in 'new_premise', with: 'There exist examples of honest politicians.'
    click_button 'Save'
    expect(find('.premises-list li', text: 'There exist examples of honest politicians.')).to be_present
    expect(statement.arguments).to be_present
  end

  context '(before publishing)' do
    let!(:argument) { FactoryGirl.create :argument, statement: statement }
    before(:each) do
      3.times do
        argument.premises << FactoryGirl.create(:premise, argument: argument)
      end
      visit argument_path(argument.id)
    end

    it 'allows editing of unpublished premises' do
      expect(all('.premises-list li', text: argument.premises[0].text)).to be_present
      expect(all('.premises-list li', text: argument.premises[1].text)).to be_present
      expect(all('.premises-list li', text: argument.premises[2].text)).to be_present
      click_link 'Edit'
      fill_in "premises[#{argument.premises[0].id}]", with: 'Premise one'
      fill_in "premises[#{argument.premises[1].id}]", with: 'Premise two'
      fill_in "premises[#{argument.premises[2].id}]", with: 'Premise three'
      click_button 'Save'
      expect(find('.premises-list li', text: 'Premise one')).to be_present
      expect(find('.premises-list li', text: 'Premise two')).to be_present
      expect(find('.premises-list li', text: 'Premise three')).to be_present
    end
  end
end
