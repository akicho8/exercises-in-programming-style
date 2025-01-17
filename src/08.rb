## 関数合成 ##

### 8. 合わせ鏡 - 再帰 ###

# 繰り返しは再帰で行う

#+BEGIN_SRC
RubyVM::InstructionSequence.compile(<<~CODE, __FILE__, __dir__, __LINE__, tailcall_optimization: true).eval
  def count(words, stop_words, word_freqs)
    if words.empty?
      return
    end
    word = words.first
    unless stop_words.include?(word)
      word_freqs[word] += 1
    end
    count(words.drop(1), stop_words, word_freqs)
  end
CODE

def print_all(word_freqs)
  if word_freqs.empty?
    return
  end
  w, f = word_freqs.first
  puts "#{w} - #{f}"
  print_all word_freqs.drop(1)
end

stop_words = File.read("stop_words.txt").scan(/\w+/).to_set
words = File.read("input.txt").downcase.scan(/[a-z]{2,}/)
words = File.read("pride-and-prejudice.txt").downcase.scan(/[a-z]{2,}/)
word_freqs = Hash.new(0)
count(words, stop_words, word_freqs)
print_all word_freqs.sort_by { -_2 }.take(25)
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

# デフォルトでは末尾再帰最適化が効いていないので普通に実行するとスタックが死ぬ。その場合 `tailcall_optimization: true` で該当コードをコンパイルするか words.each_slice(1000) などとして count を分割して呼ぶ。
