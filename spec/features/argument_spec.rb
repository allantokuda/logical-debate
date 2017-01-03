require 'spec_helper'

describe 'An argument' do
  let(:user) { FactoryGirl.create(:user) }
  let(:statement) { FactoryGirl.create :statement }

  before(:each) do
    visit '/'
    login_as user, scope: :user
    visit statement_path(statement.id)
    expect(find('.statement-heading', text: statement.text)).to be_present
    expect(statement.arguments).to_not be_present
  end

  it 'can support a statement' do
    click_link 'New argument'
    expect(find('.argument-heading', text: "Regarding: #{statement.text}")).to be_present

    fill_in 'new_premise', with: 'Honesty is unprofitable.'
    click_button 'Save'
    expect(find('.argument-explanation', text: 'supporting argument')).to be_present
    expect(find('.premises-list li', text: 'Honesty is unprofitable.')).to be_present
    expect(statement.reload.arguments).to be_present
    expect(statement.arguments.first.user).to eq user
  end

  it 'can counter a statement' do
    click_link 'New counterargument'
    expect(find('.argument-heading', text: "Regarding: #{statement.text}")).to be_present

    fill_in 'new_premise', with: 'There exist examples of honest politicians.'
    click_button 'Save'
    expect(find('.argument-explanation', text: 'counterargument')).to be_present
    expect(find('.premises-list li', text: 'There exist examples of honest politicians.')).to be_present
    expect(statement.reload.arguments).to be_present
  end

  it 'can include multiple premises' do
    click_link 'New argument'
    fill_in 'new_premise', with: 'Honesty is unprofitable.'
    click_button 'Add another premise'
    fill_in 'new_premise', with: 'Profit is king.'
    click_button 'Save'
    expect(find('.premises-list li', text: 'Honesty is unprofitable.')).to be_present
    expect(find('.premises-list li', text: 'Profit is king')).to be_present
    expect(statement.reload.arguments.last.premises.count).to eq 2
  end

  context '(before publishing)' do
    let!(:argument) { FactoryGirl.create :argument, subject_statement: statement, user: user }
    before(:each) do
      3.times do
        FactoryGirl.create(:premise, argument: argument)
      end
      visit argument_path(argument.id)
    end

    describe 'its premises' do
      it 'can be edited' do
        expect(find('.premises-list li', text: argument.premises[0].text)).to be_present
        expect(find('.premises-list li', text: argument.premises[1].text)).to be_present
        expect(find('.premises-list li', text: argument.premises[2].text)).to be_present
        click_link 'Edit'
        fill_in "premises[#{argument.premises[0].id}]", with: 'Premise one'
        fill_in "premises[#{argument.premises[1].id}]", with: 'Premise two'
        fill_in "premises[#{argument.premises[2].id}]", with: 'Premise three'
        click_button 'Save'
        expect(find('.premises-list li', text: 'Premise one')).to be_present
        expect(find('.premises-list li', text: 'Premise two')).to be_present
        expect(find('.premises-list li', text: 'Premise three')).to be_present
      end

      it 'can be deleted by resending them blank' do
        click_link 'Edit'
        fill_in "premises[#{argument.premises[0].id}]", with: ''
        click_button 'Save'
        expect(find('.premises-list li', text: argument.premises[1].text)).to be_present
        expect(find('.premises-list li', text: argument.premises[2].text)).to be_present
        expect( all('.premises-list li').count).to eq 2
      end
    end

    it 'shows on the statement page as an unpublished argument' do
      visit statement_path(argument.subject_statement)
      expect(find('.argument', text: argument.one_line)).to be_present
    end

    it 'can be published, making it no longer editable' do
      expect(find('.premises-list li', text: argument.premises[0].text)).to be_present
      expect(find('.premises-list li', text: argument.premises[1].text)).to be_present
      expect(find('.premises-list li', text: argument.premises[2].text)).to be_present
      click_button 'Publish'
      expect(find('.premises-list li', text: argument.premises[0].text)).to be_present
      expect(find('.premises-list li', text: argument.premises[1].text)).to be_present
      expect(find('.premises-list li', text: argument.premises[2].text)).to be_present
      expect(all('a', text: 'Edit')).to_not be_present
      expect(all('button', text: 'Publish')).to_not be_present
    end

    context 'if written by a different user' do
      before(:each) do
        argument.update!(user: FactoryGirl.create(:user))
      end

      it 'cannot yet be seen on the statement page' do
        visit statement_path(argument.subject_statement)
        expect(find('.statement-heading', text: argument.subject_statement.text)).to be_present
        expect(all('.arguments-table td', text: argument.one_line)).to be_blank
      end
    end
  end

  context '(once published)' do
    let(:argument) { FactoryGirl.create :argument, subject_statement: statement, user: user, published_at: Time.zone.now - 5.minutes }
    it 'can have upvotes applied and removed' do
      visit statement_path(argument.subject_statement)
      click_button 'Upvote'
      expect(Vote.last.argument).to eq argument
      expect(Vote.last.user).to eq user
      click_button 'Remove vote'
      expect(Vote.count).to be 0
    end
  end
end
