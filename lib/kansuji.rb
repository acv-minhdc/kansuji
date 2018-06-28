class String
  def to_number; end
end

$base_kanji = {:char_num => ['', '一', '二', '三', '四', '五', '六', '七', '八', '九'], :char_count => { 2 => '十', 3 => '百', 4 => '千', 5 => '万', 9 => '億', 13 => '兆', 17 => '京', 21 => '垓', 25 => '𥝱', 29 => '穣', 33 => '溝', 37 => '澗', 41 => '正', 45 => '載', 49 => '極', 53 => '恒河沙', 57 => '阿僧祇', 61 => '那由他', 64 => '不可思議', 68 => '無量大数' } }

def str_num_to_kanji(str)
  return $base_kanji[:char_num][str[0].to_i] if str.length == 1 # stop recursion
  return str_num_to_kanji(str[1, str.length - 1]) if str[0] == '0' # skip 0
  if $base_kanji[:char_count].key?(str.length)
    return (str[0] == '1' ? '' : $base_kanji[:char_num][str[0].to_i]) + $base_kanji[:char_count][str.length] + str_num_to_kanji(str[1, str.length - 1])
  else
    $base_kanji[:char_count].keys.reverse.each { |value| return str_num_to_kanji(str[0, str.length - value + 1]) + $base_kanji[:char_count][value] + str_num_to_kanji(str[str.length - value + 1, str.length - 2]) if str.length > value }
  end
end

class Numeric
  def to_kansuji
    self == 0 ? '零' : str_num_to_kanji(to_s)
  end
end
