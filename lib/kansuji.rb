class String
  def to_number; end
end

$base_kanji_char_num = ['', '一', '二', '三', '四', '五', '六', '七', '八', '九']
$base_kanji_char_count = { 2 => '十', 3 => '百', 4 => '千', 5 => '万', 9 => '億', 13 => '兆', 17 => '京' }

def string_num_to_kanji(str)
  return $base_kanji_char_num[str[0].to_i] if str.length == 1
  first_char = $base_kanji_char_num[str[0].to_i]
  return string_num_to_kanji(str[1, str.length - 1]) if first_char.empty? # skip on 0
  if $base_kanji_char_count.key?(str.length)
    return (first_char == '一' ? '' : first_char) + $base_kanji_char_count[str.length] + string_num_to_kanji(str[1, str.length - 1])
  else
    $base_kanji_char_count.keys.reverse.each do |value|
      if str.length > value
        return string_num_to_kanji(str[0, str.length - value + 1]) + string_num_to_kanji(str[str.length - value + 1, str.length - 2])
      end
    end
  end
end

class Numeric
  def to_kansuji
    return '零' if self == 0
    string_num_to_kanji(to_s)
  end
end
