### 31. マップリデュース - MapReduce ###

# 単語抽出を並列処理する

#+BEGIN_SRC
def partition(text, nlines)
  text.lines.each_slice(nlines).map do |lines|
    yield lines.join
  end
end

def split_words(text)
  words = text.downcase.scan(/[a-z]{2,}/)
  stop_words = IO.read("stop_words.txt").scan(/\w+/)
  (words - stop_words).tally # 演習問題31-2の部分カウントを適用する
end

text = IO.read("pride-and-prejudice.txt")
splits = partition(text, 200) { |e| Thread.start { split_words(e) } }.map(&:value)
freqs = splits.reduce({}) { |a, e| a.merge(e) { _2 + _3 } }
puts freqs.sort_by { -_2 }.take(25).collect { |e| e * " - " }
#+END_SRC

# 途中で `[[word1, 1], [word2, 1]]` の形式にする利点がわからなかったので単に `[word1, word2]` とした。

# `map { |e| e }` は `map { |e| Thread.start { e } }.map(&:value)` の形に置き換えることができる。

[3, 4].map { |e| e.next }                               # => [4, 5]
[3, 4].map { |e| Thread.start { e.next } }.map(&:value) # => [4, 5]

# なので並行性(演習問題31-3)を適用しない場合は次のように元に戻しても結果は変わらない。

# ```diff ruby
# -  splits = partition(text, 200) { |e| Thread.start { split_words(e) } }.map(&:value)
# +  splits = partition(text, 200) { |e| split_words(e) }
# ```
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
