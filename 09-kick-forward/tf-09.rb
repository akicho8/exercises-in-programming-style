def read_file(path, func)
  func.(IO.read(path), method(:normalize))
end

def filter_chars(str, func)
  func.(str.gsub(/[\W_]+/, " "), method(:scan))
end

def normalize(str, func)
  func.(str.downcase, method(:remove_stop_words))
end

def scan(str, func)
  func.(str.split, method(:frequencies))
end

def remove_stop_words(words, func)
  stop_words = File.read("../stop_words.txt").scan(/\w+/) + ("a".."z").to_a
  func.(words - stop_words, method(:sort))
end

def frequencies(words, func)
  func.(words.tally, method(:print_text))
end

def sort(freqs, func)
  func.(freqs.sort_by { -_2 }, method(:no_op))
end

def print_text(freqs, func)
  puts freqs.take(25).collect { |*e| e * " - " }
  func.(method(:no_op))
end

def no_op(func)
end

read_file("../pride-and-prejudice.txt", method(:filter_chars))
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
