# typed: false
class EventHub
  def initialize
    @subscriptions = Hash.new { |h, k| h[k] = [] }
  end

  def subscribe(type, handler)
    @subscriptions[type] << handler
  end

  def publish(type, *args)
    if @subscriptions[type]
      @subscriptions[type].each { |e| e.call(*args) }
    end
  end
end

class Document
  def initialize(event_hub)
    @event_hub = event_hub
    @event_hub.subscribe(:load, method(:load))
    @event_hub.subscribe(:start, method(:produce_words))
  end

  private

  def load(path_to_file)
    @data = IO.read(path_to_file)
  end

  def produce_words
    @data.downcase.scan(/[a-z]{2,}/) do |word|
      @event_hub.publish(:word, word)
    end
    @event_hub.publish(:eof)
  end
end

class StopWordList
  def initialize(event_hub)
    @stop_words = []
    @event_hub = event_hub
    @event_hub.subscribe(:load, method(:load))
    @event_hub.subscribe(:word, method(:include?))
  end

  def load(*)
    @stop_words = IO.read("../stop_words.txt").scan(/\w+/)
  end

  def include?(word)
    unless @stop_words.include?(word)
      @event_hub.publish(:valid_word, word)
    end
  end
end

class Frequency
  def initialize(event_hub)
    @word_freqs = Hash.new(0)
    @event_hub = event_hub
    @event_hub.subscribe(:valid_word, method(:increment))
    @event_hub.subscribe(:print, method(:display))
  end

  def increment(word)
    @word_freqs[word] += 1
  end

  def display
    puts @word_freqs.sort_by { -_2 }.take(25).collect { |e| e * " - " }
  end
end

class Application
  def initialize(event_hub)
    @event_hub = event_hub
    @event_hub.subscribe(:run, method(:run))
    @event_hub.subscribe(:eof, method(:stop))
  end

  def run(path_to_file)
    @event_hub.publish(:load, path_to_file)
    @event_hub.publish(:start)
  end

  def stop
    @event_hub.publish(:print)
  end
end

event_hub = EventHub.new
Document.new(event_hub)
StopWordList.new(event_hub)
Frequency.new(event_hub)
Application.new(event_hub)
event_hub.publish(:run, "../pride-and-prejudice.txt")
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
