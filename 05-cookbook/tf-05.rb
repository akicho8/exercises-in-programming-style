$data = []
$words = []
$word_freqs = []

def read_file
  $data += IO.read("../pride-and-prejudice.txt").chars
end

def filter_chars_and_normalize
  $data.collect! do |c|
    if c.match?(/\p{Alnum}/)
      c.downcase
    else
      " "
    end
  end
end

def scan
  $words += $data.join.split
end

def remove_stop_words
  $words -= IO.read("../stop_words.txt").scan(/\w+/)
  $words -= ("a".."z").to_a
end

def frequencies
  $word_freqs = $words.tally
end

def sort
  $word_freqs = $word_freqs.sort_by { |_, c| -c }
end

read_file
filter_chars_and_normalize
scan
remove_stop_words
frequencies
sort

$word_freqs.take(25).each do |v, c|
  puts "#{v} - #{c}"
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
