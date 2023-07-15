### 24. 意図の宣言 - 型注釈 ###

# ダックタイピングの敵

#+BEGIN_SRC
# typed: strict
require "sorbet-runtime"
extend T::Sig

sig { params(path_to_file: String).returns(T::Array[T.any(T::Array[String], String)]) }
def extract_words(path_to_file)
  IO.read(path_to_file).downcase.scan(/[a-z]{2,}/)
end

sig { params(words: T::Array[T.untyped]).returns(T::Array[String]) }
def remove_stop_words(words)
  stop_words = IO.read("stop_words.txt").scan(/\w+/)
  words - stop_words
end

sig { params(words: T::Array[T.untyped]).returns(T::Hash[String, Integer]) }
def frequencies(words)
  words.tally
end

sig { params(freqs: T::Hash[T.untyped, T.untyped]).returns(T::Array[T::Array[String]]) }
def sort(freqs)
  freqs.sort_by { -_2 }
end

freqs = sort(frequencies(remove_stop_words(extract_words("pride-and-prejudice.txt"))))
puts freqs.take(25).collect { |e| e * " - " }
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
