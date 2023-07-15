### 30. データ空間 - 並列処理 ###

# スレッド間のやりとりはスレッドとは独立した2つのキューのみ

#+BEGIN_SRC
require "timeout"

word_space = Queue.new
freq_space = Queue.new

stop_words = IO.read("stop_words.txt").scan(/\w+/).to_set

IO.read("pride-and-prejudice.txt").downcase.scan(/[a-z]{2,}/) do |word|
  word_space << word
end

5.times.collect { |i|
  Thread.start do
    freqs = Hash.new(0)
    loop do
      word = nil
      begin
        Timeout.timeout(1) do
          word = word_space.shift
        end
      rescue Timeout::Error
        break
      end
      Thread.pass               # 激しく分散させるため
      unless stop_words.include?(word)
        freqs[word] += 1
      end
    end
    freq_space << freqs
  end
}.each(&:join)

freqs = {}
while !freq_space.empty?
  freqs.update(freq_space.shift) { _2 + _3 }
end
puts freqs.sort_by { -_2 }.take(25).collect { |e| e * " - " }

#+END_SRC

# 1秒間暇だったらスレッドたちは自動的に終了する
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
