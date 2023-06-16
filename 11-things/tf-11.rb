class Document
  def initialize(path_to_file)
    @path_to_file = path_to_file
  end

  def each(...)
    words.each(...)
  end

  private

  def words
    @words ||= IO.read(@path_to_file).downcase.scan(/[a-z]{2,}/)
  end
end

class StopWordList
  def include?(word)
    set.include?(word)
  end

  private

  def set
    @set ||= IO.read("../stop_words.txt").scan(/\w+/).to_set
  end
end

class Frequency
  def initialize
    @freqs = Hash.new(0)
  end

  def increment(word)
    @freqs[word] += 1
  end

  def sorted
    @freqs.sort_by { -_2 }
  end
end

class Controller
  def initialize(path_to_file)
    @document = Document.new(path_to_file)
    @stop_word_list = StopWordList.new
    @frequency = Frequency.new
  end

  def run
    @document.each do |word|
      unless @stop_word_list.include?(word)
        @frequency.increment(word)
      end
    end
    puts @frequency.sorted.take(25).collect { |e| e * " - " }
  end
end

Controller.new("../pride-and-prejudice.txt").run
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
