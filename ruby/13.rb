# typed: false
data_storage_obj = {
  :data  => [],
  :init  => -> path_to_file { data_storage_obj[:data] = IO.read(path_to_file).downcase.scan(/[a-z]{2,}/) },
  :words => -> { data_storage_obj[:data] },
}

stop_words_obj = {
  :stop_words => [],
  :init       => -> { stop_words_obj[:stop_words] = IO.read("../stop_words.txt").scan(/\w+/) },
  :include?   => -> word { stop_words_obj[:stop_words].include?(word) },
}

word_freqs_obj = {
  :freqs     => Hash.new(0),
  :increment => -> word { word_freqs_obj[:freqs][word] += 1 },
  :sorted    => -> { word_freqs_obj[:freqs].sort_by { -_2 } },
  :top25     => -> { word_freqs_obj[:sorted].call.take(25) },
}

data_storage_obj[:init].call("../pride-and-prejudice.txt")
stop_words_obj[:init].call

data_storage_obj[:words].call.each do |word|
  unless stop_words_obj[:include?][word]
    word_freqs_obj[:increment][word]
  end
end

puts word_freqs_obj[:top25].call.collect { |e| e * " - " }
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
