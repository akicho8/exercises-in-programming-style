# typed: false
def extract_words(path_to_file)
  path_to_file.kind_of?(String) or raise TypeError, "I need a string!"
  !path_to_file.empty? or raise ArgumentError, "I need a non-empty string!"

  IO.read(path_to_file).downcase.scan(/[a-z]{2,}/)
end

def remove_stop_words(words)
  words.kind_of?(Array) or raise TypeError, "I need a list!"

  stop_words = IO.read("../stop_words.txt").scan(/\w+/)
  words - stop_words
end

def frequencies(words)
  words.kind_of?(Array) or raise TypeError, "I need a list!"
  !words.empty? or raise ArgumentError, "I need a non-empty list!"

  words.tally
end

def sort(freqs)
  freqs.kind_of?(Hash) or raise TypeError, "I need a dictionary!"
  !freqs.empty? or raise ArgumentError, "I need a non-empty dictionary!"

  freqs.sort_by { -_2 }
end

begin
  freqs = sort(frequencies(remove_stop_words(extract_words("../pride-and-prejudice.txt"))))
  freqs.kind_of?(Array) or raise TypeError, "OMG! This is not a list!"

  freqs.length >= 25 or raise "SRSLY? Less than 25 words!"
  puts freqs.take(25).collect { |e| e * " - " }
rescue => error
  puts error.full_message
end
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
