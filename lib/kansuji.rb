module BaseCharKanji
  class << self; attr_reader :base_kanji end
  @base_kanji = { char_num: ['', '一', '二', '三', '四', '五', '六', '七', '八', '九'], char_count: { 2 => '十', 3 => '百', 4 => '千', 5 => '万', 9 => '億', 13 => '兆', 17 => '京', 21 => '垓', 25 => '𥝱', 29 => '穣', 33 => '溝', 37 => '澗', 41 => '正', 45 => '載', 49 => '極', 53 => '恒河沙', 57 => '阿僧祇', 61 => '那由他', 64 => '不可思議', 68 => '無量大数' } }
end

class Numeric
  include BaseCharKanji
  def to_kansuji
    self == 0 ? '零' : str_num_to_kanji(to_s)
  end

  private

  def str_num_to_kanji(str)
    str = str.to_i.to_s # delete leading zero
    return BaseCharKanji.base_kanji[:char_num][str[0].to_i] if str.length == 1 # stop recursion
    count = str.length
    count -= 1 until BaseCharKanji.base_kanji[:char_count][count]
    first_char = str_num_to_kanji(str[0, str.length - count + 1])
    (first_char == '一' ? '' : first_char) + BaseCharKanji.base_kanji[:char_count][count] + str_num_to_kanji(str[str.length - count + 1, count - 1])
  end
end

class String
  include BaseCharKanji
  def to_number
    self == '零' ? 0 : kanji_to_num(self)
  end

  private

  def kanji_to_num(str)
    return 0 if str.empty?
    return BaseCharKanji.base_kanji[:char_num].find_index(str) if str.length == 1 && BaseCharKanji.base_kanji[:char_num].include?(str)
    count_char_collection = str.chars.select { |char| BaseCharKanji.base_kanji[:char_count].value?(char) }
    raise ArgumentError, 'Invalid format kanji number to convert' if count_char_collection.empty?
    max_count_char = count_char_collection.max_by { |char| BaseCharKanji.base_kanji[:char_count].key(char) }
    first_char = str[0, str.index(max_count_char)]
    (first_char.empty? ? 1 : kanji_to_num(first_char)) * 10**(BaseCharKanji.base_kanji[:char_count].key(max_count_char) - 1) + kanji_to_num(str[str.index(max_count_char) + 1, str.length - str.index(max_count_char) - 1])
  end
end
