### 20. プラグイン - 依存性注入 ###

# メインプログラムはそのままで実装を切り替える

#+code_include: src/config.yml yaml:config.yml

#+code_include: src/extract_words1.rb ruby:extract_words1.rb

#+code_include: src/frequencies1.rb ruby:frequencies1.rb

#+BEGIN_SRC ruby:main.rb
require "yaml"

config = YAML.load_file("config.yml")
eval IO.read(config.dig("plugins", "extract_words"))
eval IO.read(config.dig("plugins", "frequencies"))

word_freqs = frequencies(extract_words("pride-and-prejudice.txt"))
puts word_freqs.collect { |e| e * " - " }
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
