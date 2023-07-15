### 19. 横断的関心 - アスペクト指向 ###

# 元のコードはそのままで機能を追加する

#+BEGIN_SRC
require "active_support/core_ext/benchmark"

def extract_words(path_to_file)
  words = IO.read(path_to_file).downcase.scan(/[a-z]{2,}/)
  stop_words = IO.read("stop_words.txt").scan(/\w+/)
  words - stop_words
end

def frequencies(words)
  words.tally
end

def sort(freqs)
  freqs.sort_by { -_2 }
end

def profile(*names)
  names.each do |name|
    m = method(name)
    define_method name do |*args, &block|
      ret_value = nil
      elapsed = Benchmark.ms do
        ret_value = m.call(*args, &block)
      end
      puts "#{m.name}: #{elapsed.round(2)}ms"
      ret_value
    end
  end
end

profile :extract_words, :frequencies, :sort

freqs = sort(frequencies(extract_words("pride-and-prejudice.txt")))
puts freqs.take(25).collect { |e| e * " - " }
# >> extract_words: 54.78ms
# >> frequencies: 3.55ms
# >> sort: 0.72ms
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

# `profile :extract_words` で `extract_words` メソッドにベンチーマーク機能がつく
