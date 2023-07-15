## 異常事態 ##

### 21. 構成主義 - 防御的プログラミング ###

# エラーはなかったことにする

#+BEGIN_SRC
def extract_words(path_to_file)
  unless path_to_file.kind_of?(String) && !path_to_file.empty?
    return []
  end

  begin
    data = IO.read(path_to_file)
  rescue => error
    puts error
    return []
  end

  data.downcase.scan(/[a-z]{2,}/)
end

def remove_stop_words(words)
  unless words.kind_of?(Array)
    return []
  end

  begin
    stop_words = IO.read("stop_words.txt").scan(/\w+/)
  rescue => error
    puts error
    return words
  end

  words - stop_words
end

def frequencies(words)
  unless words.kind_of?(Array) && !words.empty?
    return {}
  end

  words.tally
end

def sort(freqs)
  unless freqs.kind_of?(Hash) && !freqs.empty?
    return []
  end

  freqs.sort_by { -_2 }
end

filename = ARGV.first || "pride-and-prejudice.txt"
freqs = sort(frequencies(remove_stop_words(extract_words(filename))))
puts freqs.take(25).collect { |e| e * " - " }
# >> mr - 786
# >> elizabeth - 635
# >> very - 488
# >> darcy - 418
# >> such - 395
# >> mrs - 343
# >> much - 329
# >> more - 327
# >> bennet - 323
# >> bingley - 306
# >> jane - 295
# >> miss - 283
# >> one - 275
# >> know - 239
# >> before - 229
# >> herself - 227
# >> though - 226
# >> well - 224
# >> never - 220
# >> sister - 218
# >> soon - 216
# >> think - 211
# >> now - 209
# >> time - 203
# >> good - 201
#+END_SRC

# * HTML や CSS が壊れていてもブラウザが止まらないはこのスタイルだから
# * Ruby で `"foo"[100]` が `nil` を返したり `"".to_i` が `0` を返すのもこのスタイル
