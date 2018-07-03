# frozen_string_literal: true

module Kanji
  class << self; attr_reader :num, :bcount end
  @num = %w[零 一 二 三 四 五 六 七 八 九]
  @bcount = { 2 => '十', 3 => '百', 4 => '千', 5 => '万', 9 => '億', 13 => '兆',
              17 => '京', 21 => '垓', 25 => '𥝱', 29 => '穣', 33 => '溝',
              37 => '澗', 41 => '正', 45 => '載', 49 => '極', 53 => '恒河沙',
              57 => '阿僧祇', 61 => '那由他', 65 => '不可思議', 69 => '無量大数' }
end
# Append method to Numeric class
class Numeric
  include Kanji
  def to_kansuji
    raise_error(NoMethodError) if to_s.include?('.')
    zero? ? '零' : num_to_kanji(to_s)
  end

  def num_to_kanji(str)
    return '' if (str = str.to_i.to_s) == '0'
    return Kanji.num[str[0].to_i] if str.length == 1
    count = str.length
    count -= 1 until Kanji.bcount[count]
    first_char = num_to_kanji(str[0, str.length - count + 1])
    (first_char == '一' && count < 5 ? '' : first_char) + Kanji.bcount[count]\
      + num_to_kanji(str[(str.length - count + 1)..-1])
  end
end
# Append method to class String
class String
  include Kanji
  def to_number
    kanji_to_num(self)
  end

  def kanji_to_num(str)
    return Kanji.num.find_index(str) if Kanji.num.include?(str)
    max_num = nil
    Kanji.bcount.each { |_k, v| max_num = [str.index(v), v] if str.index(v) }
    if max_num.nil?
      return str.chars.inject('') do |num, chr|
        num + (Kanji.num.include?(chr) ? kanji_to_num(chr).to_s : '')
      end .to_i
    end
    ((head = kanji_to_num(str[0, max_num[0]])).zero? ? 1 : head) * \
      10**(Kanji.bcount.key(max_num[1]) - 1) + kanji_to_num(str[(max_num[0] + \
        max_num[1].length)..-1])
  end
end
