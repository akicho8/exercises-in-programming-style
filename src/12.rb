### 12. レターボックス - メッセージパッシング ###

# やりとりは dispatch のみ

#+BEGIN_SRC
class Document
  def dispatch(...)
    send(...)
  end

  private

  def setup(path_to_file)
    @data = IO.read(path_to_file)
  end

  def words
    @data.downcase.scan(/[a-z]{2,}/)
  end
end

class StopWordList
  def dispatch(...)
    send(...)
  end

  private

  def setup
    @stop_words = File.read("stop_words.txt").scan(/\w+/).to_set
  end

  def include?(word)
    @stop_words.include?(word)
  end
end

class Frequency
  def initialize
    @freqs = Hash.new(0)
  end

  def dispatch(...)
    send(...)
  end

  private

  def increment(word)
    @freqs[word] += 1
  end

  def sorted
    @freqs.sort_by { -_2 }
  end
end

class Controller
  def dispatch(...)
    send(...)
  end

  private

  def setup(path_to_file)
    @document = Document.new
    @stop_word_list = StopWordList.new
    @frequency = Frequency.new

    @document.dispatch(:setup, path_to_file)
    @stop_word_list.dispatch(:setup)
  end

  def run
    @document.dispatch(:words).each do |word|
      unless @stop_word_list.dispatch(:include?, word)
        @frequency.dispatch(:increment, word)
      end
    end
    puts @frequency.dispatch(:sorted).take(25).collect { |e| e * " - " }
  end
end

controller = Controller.new
controller.dispatch(:setup, "pride-and-prejudice.txt")
controller.dispatch(:run)
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
