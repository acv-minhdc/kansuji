module Kanji
  class << self; attr_reader :no, :bcount end
  @no = %w[零 一 二 三 四 五 六 七 八 九]
  @bcount = { 2 => '十', 3 => '百', 4 => '千', 5 => '万', 9 => '億', 13 => '兆',
              17 => '京', 21 => '垓', 25 => '𥝱', 29 => '穣', 33 => '溝',
              37 => '澗', 41 => '正', 45 => '載', 49 => '極', 53 => '恒河沙',
              57 => '阿僧祇', 61 => '那由他', 65 => '不可思議', 69 => '無量大数' }
end
# Append method to Numeric class
class Integer
  def to_kansuji(str = self)
    return Kanji.no[str.to_i] if (count = (str = str.to_i.to_s).length) == 1
    count -= 1 until Kanji.bcount[count]
    first_char = to_kansuji(str[0, str.length - count + 1])
    (first_char == '一' && count < 5 ? '' : first_char) + Kanji.bcount[count]\
    + ((t = to_kansuji(str[(str.length - count + 1)..-1])) == '零' ? '' : t)
  end
end
# Append method to class String
class String
  def to_number(str = self)
    return Kanji.no.find_index(str) if Kanji.no.include?(str)
    return str.chars.inject('') { |n, c| n + Kanji.no.find_index(c).to_s }.to_i\
      unless (max = Kanji.bcount.values.reverse.find { |v| str.index(v) })
    max = [str.index(max), max]
    ((head = to_number(str[0, max[0]])).zero? ? 1 : head) * 10**(Kanji.bcount\
      .key(max[1]) - 1) + to_number(str[(max[0] + max[1].length)..-1])
  end
end
