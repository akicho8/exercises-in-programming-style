### 18. 自己反映性 - リフレクション ###

# 実行時にコードを自分で作る

#+BEGIN_SRC
stops = IO.read("stop_words.txt").scan(/\w+/)

if true
  extract_words_func = %(-> path_to_file { File.read(path_to_file).downcase.scan(/[a-z]{2,}/) - stops })
  frequencies_func = %(-> words { words.tally })
  sort_func = %(-> freqs { freqs.sort_by { -_2 } })
  path_to_name = "pride-and-prejudice.txt"
else
  extract_words_func = %(-> path_to_file { [] })
  frequencies_func = %(-> words { [] })
  sort_func = %(-> freqs { {} })
  path_to_name = __FILE__
end

extract_words = eval(extract_words_func)
frequencies = eval(frequencies_func)
sort = eval(sort_func)

freqs = sort[frequencies[extract_words[path_to_name]]]
puts freqs.take(25).collect { |e| e * " - " }
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
