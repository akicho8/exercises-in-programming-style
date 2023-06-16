# typed: false
class Framework
  def initialize
    @load_event_handlers = []
    @dowork_event_handlers = []
    @end_event_handlers = []
  end

  def register_for_load_event(handler)
    @load_event_handlers << handler
  end

  def register_for_dowork_event(handler)
    @dowork_event_handlers << handler
  end

  def register_for_end_event(handler)
    @end_event_handlers << handler
  end

  def run(path_to_file)
    @load_event_handlers.each { |e| e.call(path_to_file) }
    @dowork_event_handlers.each(&:call)
    @end_event_handlers.each(&:call)
  end
end

class Document
  attr_reader :word_event_handlers

  def initialize(app, stop_word_list)
    @word_event_handlers = []
    app.register_for_load_event(method(:load))
    app.register_for_dowork_event(method(:produce_words))
    @stop_word_list = stop_word_list
  end

  private

  def load(path_to_file)
    @data = IO.read(path_to_file)
  end

  def produce_words
    @data.downcase.scan(/[a-z]{2,}/) do |word|
      unless @stop_word_list.include?(word)
        @word_event_handlers.each { |e| e.call(word) }
      end
    end
  end
end

class StopWordList
  def initialize(app)
    app.register_for_load_event(method(:load))
  end

  def include?(word)
    @stop_words.include?(word)
  end

  private

  def load(...)
    @stop_words = IO.read("../stop_words.txt").scan(/\w+/).to_set
  end
end

class Frequency
  def initialize(app, document)
    @freqs = Hash.new(0)
    document.word_event_handlers << method(:increment)
    app.register_for_end_event(method(:display))
  end

  private

  def increment(word)
    @freqs[word] += 1
  end

  def display
    puts @freqs.sort_by { -_2 }.take(25).collect { |e| e * " - " }
  end
end

app = Framework.new
stop_word_list = StopWordList.new(app)
document = Document.new(app, stop_word_list)
frequency = Frequency.new(app, document)
app.run("../pride-and-prejudice.txt")
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
