### 25. 検疫 - 純粋関数と不純関数 ###

# 表示を伴なうような不純関数を遅延評価させて純粋関数化する

#+BEGIN_SRC
class Quarantine
  def initialize
    @funcs = []
  end

  def bind(func)
    @funcs << func
    self
  end

  def execute
    value = @funcs.reduce(-> {}) { |a, e| e[guard_callable(a)] }
    puts guard_callable(value)
  end

  private

  def guard_callable(value)
    if value.respond_to?(:call)
      value.call
    else
      value
    end
  end
end

def get_input(*)
  -> { ARGV.first || "pride-and-prejudice.txt" }
end

def extract_words(path_to_file)
  -> { IO.read(path_to_file).downcase.scan(/[a-z]{2,}/) }
end

def remove_stop_words(words)
  -> { words - IO.read("stop_words.txt").scan(/\w+/) }
end

def frequencies(words)
  words.tally
end

def sort(freqs)
  freqs.sort_by { -_2 }
end

def top25_freqs(freqs)
  puts freqs.take(25).collect { |e| e * " - " }
end

Quarantine.new
  .bind(method(:get_input))
  .bind(method(:extract_words))
  .bind(method(:remove_stop_words))
  .bind(method(:frequencies))
  .bind(method(:sort))
  .bind(method(:top25_freqs))
  .execute
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
# >> 
