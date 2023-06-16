require "active_support/core_ext/module/delegation"

class ActiveObject
  delegate :<<, to: :@queue
  delegate :join, to: :@thread
  private delegate :kill, to: :@thread

  def initialize
    @queue = Queue.new
    @thread = Thread.start do
      loop do
        dispatch(*@queue.shift)
      end
    end
  end

  private

  # def dispatch(type, *args)
  #   # puts "#{self.class.name}##{type}"
  #   send(type, *args)
  # end

  def dispatch(...)
    send(...)
  end
end

class Document < ActiveObject
  private

  def setup(path_to_file, stop_word_list)
    @stop_word_list = stop_word_list
    @data = IO.read(path_to_file)
  end

  def process_words(recipient)
    @data.downcase.scan(/[a-z]{2,}/) do |word|
      @stop_word_list << [:filter, word]
    end
    @stop_word_list << [:sorted, recipient]
  end

  def kill
    @stop_word_list << [:kill]
    super
  end
end

class StopWordList < ActiveObject
  private

  def setup(frequency)
    @frequency = frequency
    @stop_words = IO.read("../stop_words.txt").scan(/\w+/).to_set
  end

  def filter(word)
    unless @stop_words.include?(word)
      @frequency << [:increment, word]
    end
  end

  def sorted(recipient)
    @frequency << [:sorted, recipient]
  end

  def kill
    @frequency << [:kill]
    super
  end
end

class Frequency < ActiveObject
  private

  def increment(word)
    freqs[word] += 1
  end

  def sorted(recipient)
    recipient << [:top25, freqs.sort_by { -_2 }]
  end

  def freqs
    @freqs ||= Hash.new(0)
  end
end

class Controller < ActiveObject
  private

  def run(document)
    @document = document
    @document << [:process_words, self]
  end

  def top25(sorted)
    puts sorted.take(25).collect { |e| e * " - " }
    # (Thread.list - [Thread.main]).each(&:kill)
    self << [:kill]
  end

  def kill
    @document << [:kill]
    super
  end
end

frequency = Frequency.new
stop_word_list = StopWordList.new
stop_word_list << [:setup, frequency]
document = Document.new
document << [:setup, "../pride-and-prejudice.txt", stop_word_list]
controller = Controller.new
controller << [:run, document]

[frequency, stop_word_list, document, controller].each(&:join)
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
