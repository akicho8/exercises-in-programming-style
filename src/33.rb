## 対話性 ##

### 33. 三位一体 - MVC ###

# データと表示と制御に分ける

#+BEGIN_SRC
class WordFrequenciesModel
  attr_accessor :freqs

  def initialize(path_to_file)
    @freqs = {}
    update(path_to_file)
  end

  def update(path_to_file)
    words = IO.read(path_to_file).downcase.scan(/[a-z]{2,}/)
    @freqs = (words - stop_words).tally
  end

  private

  def stop_words
    @stop_words ||= IO.read("stop_words.txt").scan(/\w+/)
  end
end

class WordFrequenciesView
  def initialize(model)
    @model = model
  end

  def render
    sorted_freqs = @model.freqs.sort_by { -_2 }.take(25)
    puts sorted_freqs.collect { |e| e * " - " }
  end
end

class WordFrequencyController
  def initialize(model, view)
    @model, @view = model, view
  end

  def show
    @view.render
  end
end

m = WordFrequenciesModel.new("pride-and-prejudice.txt")
v = WordFrequenciesView.new(m)
c = WordFrequencyController.new(m, v)
c.show
#+END_SRC

# * 分離する基準が人によって異なる
# * 上のコードの場合、並び替えの債務が定まらない
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
