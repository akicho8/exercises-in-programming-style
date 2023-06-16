# typed: false
def read_stop_words
  if caller_locations(1..1).first.label == "extract_words"
    IO.read("../stop_words.txt").scan(/\w+/)
  end
end

def extract_words(path_to_file)
  data = IO.read(binding.local_variable_get(:path_to_file))
  words = data.downcase.scan(/[a-z]{2,}/)
  words - read_stop_words
end

def frequencies(words)
  binding.local_variable_get(:words).tally
end

freqs = frequencies(extract_words("../pride-and-prejudice.txt"))
puts freqs.sort_by { -_2 }.take(25).collect { |e| e * " - " }
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
