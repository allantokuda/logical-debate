require 'spec_helper'

describe 'A premise' do
  let(:premise) { FactoryGirl.create :premise }
  let(:argument) { premise.argument }
  let(:original_statement) { argument.statement }

  before(:each) do
    visit premise_path(premise.id)
  end

  it 'can be agreed with' do
    find('.premise-agree').click
  end

  it 'can be disagreed with as a premise for an argument, but agreed with as a standalone statement' do
    find('.premise-disagree').click
  end

  it 'can be disputed as a standalone statement' do
    find('.premise-statement-disagree').click
  end

end
