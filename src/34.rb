### 34. レストフル - ステートレス ###

# セッションの状態はクライアントが持つ

#+BEGIN_SRC
class Server
  def initialize
    @data = {}
  end

  def handle_request(verb, uri, *args)
    send("handler_#{verb}_#{uri}".downcase, *args)
  end

  private

  def handler_get_default
    rep = []
    rep << "What would you like to do?"
    rep << "1 - Quit"
    rep << "2 - Upload file"
    links = {
      "1" => ["POST", "quit"],
      "2" => ["GET", "file_form"],
    }
    [rep, links]
  end

  def handler_post_quit
    puts "Goodbye cruel world..."
    exit
  end

  def handler_get_file_form
    ["Name of file to upload?", ["POST", "file"]]
  end

  def handler_post_file(filename)
    create_data(filename)
    handler_get_word(filename, 0)
  end

  def handler_get_word(filename, index)
    word, count = freq_at_index(filename, index)
    rep = []
    rep << "##{index.next}: #{word} - #{count}"
    rep << "What would you like to do next?"
    rep << "1 - Quit"
    rep << "2 - Upload file"
    rep << "3 - See next most-frequently occurring word"
    links = {
      "1" => ["POST", "quit"],
      "2" => ["GET", "file_form"],
      "3" => ["GET", "word", filename, index.next],
    }
    [rep, links]
  end

  def freq_at_index(filename, index)
    @data[filename][index] || ["no more words", 0]
  end

  def create_data(filename)
    @data[filename] ||= yield_self do
      words = IO.read(filename).downcase.scan(/[a-z]{2,}/)
      @data[filename] = (words - stop_words).tally.sort_by { -_2 }
    end
  end

  def stop_words
    @stop_words ||= IO.read("stop_words.txt").scan(/\w+/)
  end
end

class Client
  def initialize
    @server = Server.new
  end

  def run
    request = ["GET", "default"]
    loop do
      state_representation, links = @server.handle_request(*request)
      request = render_and_get_input(state_representation, links)
    end
  end

  private

  def render_and_get_input(state_representation, links)
    puts state_representation
    case
    when links.kind_of?(Hash)
      links.fetch(input)
    when links.first == "POST"
      links + [input]
    else
      links
    end
  end

  def input
    print "> "
    gets.strip
  end
end

if true
  server = Server.new

  server.handle_request("GET", "default")                               # => [["What would you like to do?", "1 - Quit", "2 - Upload file"], {"1"=>["POST", "quit"], "2"=>["GET", "file_form"]}]
  server.handle_request("POST", "file", "input.txt")                 # => [["#1: live - 2", "What would you like to do next?", "1 - Quit", "2 - Upload file", "3 - See next most-frequently occurring word"], {"1"=>["POST", "quit"], "2"=>["GET", "file_form"], "3"=>["GET", "word", "input.txt", 1]}]
  server.handle_request("GET", "word", "input.txt", 0)               # => [["#1: live - 2", "What would you like to do next?", "1 - Quit", "2 - Upload file", "3 - See next most-frequently occurring word"], {"1"=>["POST", "quit"], "2"=>["GET", "file_form"], "3"=>["GET", "word", "input.txt", 1]}]
  server.handle_request("GET", "word", "input.txt", 1)               # => [["#2: mostly - 2", "What would you like to do next?", "1 - Quit", "2 - Upload file", "3 - See next most-frequently occurring word"], {"1"=>["POST", "quit"], "2"=>["GET", "file_form"], "3"=>["GET", "word", "input.txt", 2]}]
  server.handle_request("GET", "word", "input.txt", 100)             # => [["#101: no more words - 0", "What would you like to do next?", "1 - Quit", "2 - Upload file", "3 - See next most-frequently occurring word"], {"1"=>["POST", "quit"], "2"=>["GET", "file_form"], "3"=>["GET", "word", "input.txt", 101]}]

  server.handle_request("GET", "default")                               # => [["What would you like to do?", "1 - Quit", "2 - Upload file"], {"1"=>["POST", "quit"], "2"=>["GET", "file_form"]}]
  server.handle_request("POST", "file", "pride-and-prejudice.txt")   # => [["#1: mr - 786", "What would you like to do next?", "1 - Quit", "2 - Upload file", "3 - See next most-frequently occurring word"], {"1"=>["POST", "quit"], "2"=>["GET", "file_form"], "3"=>["GET", "word", "pride-and-prejudice.txt", 1]}]
  server.handle_request("GET", "word", "pride-and-prejudice.txt", 1) # => [["#2: elizabeth - 635", "What would you like to do next?", "1 - Quit", "2 - Upload file", "3 - See next most-frequently occurring word"], {"1"=>["POST", "quit"], "2"=>["GET", "file_form"], "3"=>["GET", "word", "pride-and-prejudice.txt", 2]}]
end

Client.new.run
#+END_SRC

# ```:対話
# What would you like to do?
# 1 - Quit
# 2 - Upload file
# > 2
# Name of file to upload?
# > pride-and-prejudice.txt
# #1: mr - 786
# What would you like to do next?
# 1 - Quit
# 2 - Upload file
# 3 - See next most-frequently occurring word
# > 3
# #2: elizabeth - 635
# What would you like to do next?
# 1 - Quit
# 2 - Upload file
# 3 - See next most-frequently occurring word
# > 1
# Goodbye cruel world...
# ```

# ログインすればWEBサーバーがセッションの状態を持っているように感じるがそれはブラウザ側からクッキーを渡しているからなので、そう考えればサーバー側はセッションの状態を持ってないと言える。
