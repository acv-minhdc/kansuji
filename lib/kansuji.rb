$base_kanji = { char_num: ['', '一', '二', '三', '四', '五', '六', '七', '八', '九'], char_count: { 2 => '十', 3 => '百', 4 => '千', 5 => '万', 9 => '億', 13 => '兆', 17 => '京', 21 => '垓', 25 => '𥝱', 29 => '穣', 33 => '溝', 37 => '澗', 41 => '正', 45 => '載', 49 => '極', 53 => '恒河沙', 57 => '阿僧祇', 61 => '那由他', 64 => '不可思議', 68 => '無量大数' } }

def str_num_to_kanji(str)
  str = str.to_i.to_s # delete leading zero
  return $base_kanji[:char_num][str[0].to_i] if str.length == 1 # stop recursion
  count = str.length
  count -= 1 until $base_kanji[:char_count][count]
  first_char = str_num_to_kanji(str[0, str.length - count + 1])
  (first_char == '一' ? '' : first_char) + $base_kanji[:char_count][count] + str_num_to_kanji(str[str.length - count + 1, count - 1])
end

class Numeric
  def to_kansuji
    self == 0 ? '零' : str_num_to_kanji(to_s)
  end
end

class String
  def to_number
    str = reverse
    result = ''
    parse_kanji = $base_kanji[:char_count]
    str.each_char.with_index do |char, index|
      if index.even?
        chart_to_num = $base_kanji[:char_num].find_index(char)
        result += if chart_to_num
                    chart_to_num.to_s
                  else
                    result.empty? ? '0' : '1'
                  end
      else
        expect_count, expect_char = parse_kanji.first
        until parse_kanji.shift.include?(char); end
        result += '0' * (parse_kanji.key(char) - expect_count - 1)
      end
    end
    result.reverse!.to_i
  end
end
