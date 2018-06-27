require 'rails_helper'
require 'kansuji'

RSpec.describe 'Kansuji test' do
  it 'right' do
    expect(111111.to_kansuji).to eq '一万千百十一'
  end
end
