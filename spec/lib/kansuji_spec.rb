# frozen_string_literal: true

require 'rails_helper'
require 'kansuji'

RSpec.describe 'Kansuji test lib' do
  # num -> kanji
  context 'Kansuji test: kanji -> num' do
    describe 'general case' do
      it 'remove 零(zero) head before convert' do
        expect('十一一零'.to_number).to eq 10 + 110
        expect('零一'.to_number).to eq 1
        expect('零十一'.to_number).to eq 11
      end

      it '10^0' do
        expect('零'.to_number).to eq 0
        expect('一'.to_number).to eq 1
        expect('九'.to_number).to eq 9
      end

      it '10^1' do
        expect('十'.to_number).to eq 10
        expect('十一'.to_number).to eq 11
        expect('十八'.to_number).to eq 18
        expect('一十八'.to_number).to eq 18
      end

      it '10^2' do
        expect('百'.to_number).to eq 100
        expect('百一'.to_number).to eq 101
        expect('百十一'.to_number).to eq 111
      end

      it '10^3' do
        expect('千'.to_number).to eq 1000
        expect('千一'.to_number).to eq 1001
        expect('千七百'.to_number).to eq 1700
      end

      it '10^10' do
        expect('')
      end

      it 'long int' do
        expect('七百五十四億五千四百六十五万二千三百五十二'.to_number).to eq 75_454_652_352
        expect('四千四百十三溝五千四百五十四穣八千九百四十四𥝱六千五百四十六垓七千六百七十九\
        京四千四百六十五兆四千五百七十四億六千二百十五万六千三百二十四'.to_number).to eq\
          441_354_548_944_654_676_794_465_457_462_156_324
      end
    end

    describe 'Speacial cases' do
      it 'empty string will convert to 0' do
        expect(''.to_number).to eq 0
      end

      it 'Ignore strange(non kanji) characters' do
        expect('!@!##%$#$%#$%$一十八'.to_number).to eq 18
        expect('!@!##%$十八#$%#$%$'.to_number).to eq 18
        expect('一!@!##%$十$$$$八#$%#$%$'.to_number).to eq 18
        expect('!@!##%$_十$$se232535fsefs    efe$$八_#$%#$%$'.to_number).to eq 18
      end

      it 'Strange characters(no any kanji) will convert to 0' do
        expect('Hello World 1234567 !@#$%%^&&*'.to_number).to eq 0
      end

      it 'Short rule' do
        expect('一二三四五'.to_number).to eq 12_345
        expect('五四三二一'.to_number).to eq 54_321
      end

      it 'Mix rule' do
        expect('十一一'.to_number).to eq 21 # 10 + 11
        expect('十一一零'.to_number).to eq 10 + 110
        expect('兆十一一零零'.to_number).to eq 10**12 + 10 + 1100
      end

      it 'still right when bonus 一 before count char' do
        expect('十一万千百十一'.to_number).to eq 111_111
        expect('一十一万一千一百一十一'.to_number).to eq 111_111
      end
    end
  end

  # kanji -> num
  context 'Kansuji test: num -> kanji' do
    it 'general cases' do
      expect(0.to_kansuji).to eq '零'
      expect(1.to_kansuji).to eq '一'
      expect(11.to_kansuji).to eq '十一'
      expect(110_000.to_kansuji).to eq '十一万'
      expect((10**20 + 4 * 10**16).to_kansuji).to eq '垓四京'
      expect(441_354_548_944_654_676_794_465_457_462_156_324.to_kansuji).to\
        eq '四千四百十三溝五千四百五十四穣八千九百四十四𥝱六千五百四十六垓七千六百七十九京四\
        千四百六十五兆四千五百七十四億六千二百十五万六千三百二十四'
    end
  end
end
