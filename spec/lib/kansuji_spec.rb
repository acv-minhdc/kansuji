require 'rails_helper'
require 'kansuji'

RSpec.describe 'test' do
  it 'Kansuji test: num -> kanji' do
    expect(111111.to_kansuji).to eq '十一万千百十一'
    expect(75454652352.to_kansuji).to eq '七百五十四億五千四百六十五万二千三百五十二'
    expect(7545465235289756812.to_kansuji).to eq '七百五十四京五千四百六十五兆二千三百五十二億八千九百七十五万六千八百十二'
    expect(0.to_kansuji).to eq '零'
    expect((10 ** 20 + 4*10**16).to_kansuji).to eq '垓四京'
    expect((10 ** 24).to_kansuji).to eq '𥝱'
    expect(441354548944654676794465457462156324.to_kansuji).to eq '四千四百十三溝五千四百五十四穣八千九百四十四𥝱六千五百四十六垓七千六百七十九京四千四百六十五兆四千五百七十四億六千二百十五万六千三百二十四'
  end

  it 'Kansuji test: kanji -> num' do
    expect('十一万千百十一'.to_number).to eq 111111
  end
end
