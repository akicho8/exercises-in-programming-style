### 10. 単子 - モナド ###

# 右から左に実行するイメージになってしまうパイプラインの問題を解決する

#+BEGIN_SRC
class TFTheOne
  def initialize(value)
    @value = value
  end

  def bind(func)
    @value = func[@value]
    self
  end

  def to_s
    @value.to_s
  end
end

def read_file(path)
  IO.read(path)
end

def filter_chars(str)
  str.gsub(/[\W_]+/, " ")
end

def normalize(str)
  str.downcase
end

def scan(str)
  str.split
end

def remove_stop_words(words)
  stop_words = IO.read("stop_words.txt").scan(/\w+/) + ("a".."z").to_a
  words - stop_words
end

def frequencies(words)
  words.tally
end

def sort(freqs)
  freqs.sort_by { -_2 }
end

def top25_freqs(freqs)
  freqs.take(25).collect { |e| e * " - " } * "\n"
end

TFTheOne.new("pride-and-prejudice.txt")
  .bind(method(:read_file))
  .bind(method(:filter_chars))
  .bind(method(:normalize))
  .bind(method(:scan))
  .bind(method(:remove_stop_words))
  .bind(method(:frequencies))
  .bind(method(:sort))
  .bind(method(:top25_freqs))
  .display
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

# * 適用するメソッドを順に書ける
#   * パイプラインでは右から左だったが右から左(または上から下)になっている
# * 値が順に変化していく様子はカプセル化されたクックブックスタイルにも見える
# * 次のような一時変数をブラックボックス化したものとも言える
