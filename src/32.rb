### 32. 二重マップリデュース - Hadoop ###

# 単語抽出を並列処理したあと再編成して頻度集計も並列処理する

#+BEGIN_SRC
def partition(text, nlines)
  text.lines.each_slice(nlines).map do |lines|
    yield lines.join
  end
end

def split_words(text)
  words = text.downcase.scan(/[a-z]{2,}/)
  stop_words = IO.read("stop_words.txt").scan(/\w+/)
  words - stop_words
end

text = IO.read("pride-and-prejudice.txt")
splits = partition(text, 200) { |e| Thread.start { split_words(e) } }.map(&:value)
splits_per_word = splits.reduce({}) { |a, e| a.merge(e.group_by(&:itself)) { _2 + _3 } }
freqs = splits_per_word.map { |k, v| Thread.start { [k, v.size] } }.map(&:value)
puts freqs.sort_by { -_2 }.take(25).collect { |e| e * " - " }
#+END_SRC
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
