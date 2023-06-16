# typed: false
def read_file(path_to_file)
  IO.read(path_to_file)
end

def filter_chars_and_normalize(str_data)
  str_data.downcase.gsub(/[\W_]+/, " ")
end

def scan(str_data)
  str_data.split
end

def remove_stop_words(word_list)
  word_list - [*IO.read("../stop_words.txt").scan(/\w+/), *"a".."z"]
end

def frequencies(word_list)
  word_list.tally
end

def sort(word_freqs)
  word_freqs.sort_by { -_2 }
end

def print_all(word_freqs)
  if word_freqs.empty?
    return
  end
  w, f = word_freqs.first
  puts "#{w} - #{f}"
  print_all word_freqs.drop(1)
end

print_all(sort(frequencies(remove_stop_words(scan(filter_chars_and_normalize(read_file("../pride-and-prejudice.txt")))))).take(25))
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
