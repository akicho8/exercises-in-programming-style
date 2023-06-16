def lines(path_to_file)
  File.open(path_to_file) do |f|
    f.each_line do |line|
      yield line.downcase
    end
  end
end

def all_words(path_to_file)
  lines(path_to_file) do |line|
    line.scan(/[a-z]{2,}/) do |word|
      yield word
    end
  end
end

def non_stop_words(path_to_file)
  stop_words = IO.read("../stop_words.txt").scan(/\w+/).to_set
  all_words(path_to_file) do |word|
    unless stop_words.include?(word)
      yield word
    end
  end
end

def count_and_sort(path_to_file)
  freqs = Hash.new(0)
  i = 0
  non_stop_words(path_to_file) do |word|
    freqs[word] += 1
    if i.modulo(5000).zero?
      yield freqs.sort_by { -_2 }
    end
    i += 1
  end
  yield freqs.sort_by { -_2 }
end

count_and_sort("../pride-and-prejudice.txt") do |freqs|
  puts "-----------------------------"
  puts freqs.take(25).collect { |e| e * " - " }
end
# >> -----------------------------
# >> project - 1
# >> -----------------------------
# >> mr - 94
# >> bingley - 69
# >> very - 58
# >> bennet - 52
# >> miss - 48
# >> elizabeth - 43
# >> jane - 39
# >> much - 39
# >> darcy - 38
# >> such - 36
# >> mrs - 36
# >> more - 33
# >> one - 33
# >> well - 27
# >> though - 26
# >> know - 25
# >> good - 24
# >> think - 22
# >> never - 22
# >> two - 20
# >> room - 20
# >> indeed - 19
# >> man - 19
# >> lucas - 19
# >> sisters - 18
# >> -----------------------------
# >> mr - 181
# >> bingley - 131
# >> very - 112
# >> bennet - 108
# >> elizabeth - 99
# >> miss - 96
# >> darcy - 86
# >> much - 81
# >> mrs - 69
# >> such - 67
# >> jane - 62
# >> one - 61
# >> more - 55
# >> good - 44
# >> know - 43
# >> well - 43
# >> think - 41
# >> never - 39
# >> before - 36
# >> though - 36
# >> room - 36
# >> sister - 35
# >> man - 34
# >> soon - 34
# >> young - 34
# >> -----------------------------
# >> mr - 329
# >> very - 170
# >> bingley - 167
# >> elizabeth - 158
# >> darcy - 155
# >> bennet - 128
# >> miss - 116
# >> much - 113
# >> such - 109
# >> mrs - 98
# >> one - 85
# >> jane - 83
# >> more - 81
# >> though - 62
# >> think - 61
# >> well - 60
# >> lady - 58
# >> never - 58
# >> man - 58
# >> know - 58
# >> good - 57
# >> being - 56
# >> young - 51
# >> room - 50
# >> two - 50
# >> -----------------------------
# >> mr - 418
# >> elizabeth - 213
# >> very - 209
# >> bingley - 188
# >> bennet - 176
# >> darcy - 170
# >> miss - 150
# >> much - 138
# >> such - 138
# >> mrs - 132
# >> jane - 123
# >> more - 112
# >> collins - 101
# >> one - 101
# >> think - 89
# >> though - 81
# >> being - 78
# >> know - 75
# >> never - 74
# >> well - 74
# >> man - 72
# >> herself - 70
# >> lady - 70
# >> before - 70
# >> good - 70
# >> -----------------------------
# >> mr - 479
# >> elizabeth - 285
# >> very - 267
# >> bingley - 199
# >> darcy - 194
# >> bennet - 184
# >> miss - 182
# >> such - 167
# >> mrs - 166
# >> much - 164
# >> collins - 144
# >> jane - 142
# >> more - 141
# >> one - 122
# >> lady - 113
# >> think - 111
# >> though - 100
# >> well - 99
# >> herself - 93
# >> being - 93
# >> never - 92
# >> know - 90
# >> soon - 88
# >> time - 88
# >> before - 86
# >> -----------------------------
# >> mr - 554
# >> elizabeth - 319
# >> very - 308
# >> darcy - 257
# >> bingley - 220
# >> miss - 195
# >> bennet - 188
# >> much - 187
# >> such - 185
# >> mrs - 177
# >> more - 168
# >> collins - 158
# >> jane - 158
# >> one - 147
# >> lady - 131
# >> think - 130
# >> herself - 126
# >> though - 116
# >> well - 113
# >> sister - 109
# >> never - 108
# >> soon - 107
# >> know - 107
# >> being - 107
# >> before - 106
# >> -----------------------------
# >> mr - 595
# >> elizabeth - 383
# >> very - 357
# >> darcy - 282
# >> such - 228
# >> bingley - 224
# >> much - 219
# >> mrs - 218
# >> miss - 208
# >> bennet - 203
# >> more - 194
# >> jane - 183
# >> one - 178
# >> collins - 167
# >> herself - 150
# >> think - 146
# >> lady - 143
# >> well - 134
# >> never - 132
# >> sister - 126
# >> know - 125
# >> though - 124
# >> soon - 123
# >> before - 123
# >> little - 121
# >> -----------------------------
# >> mr - 641
# >> elizabeth - 454
# >> very - 387
# >> darcy - 337
# >> such - 273
# >> mrs - 249
# >> much - 246
# >> bingley - 246
# >> miss - 242
# >> more - 227
# >> bennet - 206
# >> one - 202
# >> jane - 193
# >> herself - 183
# >> collins - 167
# >> think - 158
# >> though - 156
# >> never - 151
# >> well - 150
# >> lady - 149
# >> before - 149
# >> sister - 146
# >> know - 146
# >> little - 141
# >> soon - 140
# >> -----------------------------
# >> mr - 688
# >> elizabeth - 503
# >> very - 413
# >> darcy - 343
# >> such - 318
# >> mrs - 284
# >> much - 269
# >> more - 254
# >> miss - 251
# >> bennet - 249
# >> bingley - 246
# >> one - 235
# >> jane - 229
# >> herself - 196
# >> before - 185
# >> well - 176
# >> though - 175
# >> think - 174
# >> know - 174
# >> collins - 170
# >> never - 169
# >> sister - 168
# >> soon - 167
# >> good - 164
# >> now - 164
# >> -----------------------------
# >> mr - 738
# >> elizabeth - 569
# >> very - 459
# >> darcy - 369
# >> such - 354
# >> mrs - 324
# >> much - 293
# >> bennet - 293
# >> more - 288
# >> bingley - 281
# >> jane - 271
# >> miss - 265
# >> one - 262
# >> herself - 213
# >> know - 208
# >> before - 206
# >> well - 204
# >> though - 202
# >> sister - 201
# >> never - 194
# >> soon - 193
# >> time - 188
# >> think - 188
# >> wickham - 188
# >> good - 183
# >> -----------------------------
# >> mr - 786
# >> elizabeth - 635
# >> very - 487
# >> darcy - 418
# >> such - 389
# >> mrs - 343
# >> much - 328
# >> more - 326
# >> bennet - 323
# >> bingley - 306
# >> jane - 295
# >> miss - 283
# >> one - 275
# >> know - 238
# >> before - 227
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
# >> -----------------------------
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
