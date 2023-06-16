# data = IO.read("../pride-and-prejudice.txt")
data = "Hello  World!"
characters = " #{data} ".chars                                 # => [" ", "H", "e", "l", "l", "o", " ", " ", "W", "o", "r", "l", "d", "!", " "]
characters = characters.map(&:downcase)                        # => [" ", "h", "e", "l", "l", "o", " ", " ", "w", "o", "r", "l", "d", "!", " "]
characters = characters.map { |e| e.sub(/\P{Alpha}/, " ") }    # => [" ", "h", "e", "l", "l", "o", " ", " ", "w", "o", "r", "l", "d", " ", " "]
sp = characters.map.with_index { |e, i| e == " " && i || nil } # => [0, nil, nil, nil, nil, nil, 6, 7, nil, nil, nil, nil, nil, 13, 14]
sp = sp.compact                                                # => [0, 6, 7, 13, 14]
w_ranges = sp.each_cons(2).to_a                                # => [[0, 6], [6, 7], [7, 13], [13, 14]]
w_ranges = w_ranges.find_all { |a, b| (b - a) > 2 }            # => [[0, 6], [7, 13]]
words = w_ranges.map { |a, b| characters[a..b] }               # => [[" ", "h", "e", "l", "l", "o", " "], [" ", "w", "o", "r", "l", "d", " "]]
swords = words.map(&:join).map(&:strip)                        # => ["hello", "world"]
stop_words = IO.read("../stop_words.txt").scan(/\w+/).to_set   # => #<Set: {"a", "able", "about", "across", "after", "all", "almost", "also", "am", "among", "an", "and", "any", "are", "as", "at", "be", "because", "been", "but", "by", "can", "cannot", "could", "dear", "did", "do", "does", "either", "else", "ever", "every", "for", "from", "get", "got", "had", "has", "have", "he", "her", "hers", "him", "his", "how", "however", "i", "if", "in", "into", "is", "it", "its", "just", "least", "let", "like", "likely", "may", "me", "might", "most", "must", "my", "neither", "no", "nor", "not", "of", "off", "often", "on", "only", "or", "other", "our", "own", "rather", "said", "say", "says", "she", "should", "since", "so", "some", "than", "that", "the", "their", "them", "then", "there", "these", "they", "this", "tis", "to", "too", "twas", "us", "wants", "was", "we", "were", "what", "when", "where", "which", "while", "who", "whom", "why", "will", "with", "would", "yet", "you", "your"}>
ns_words = swords.reject(&stop_words.method(:include?))        # => ["hello", "world"]
uniq = ns_words.tally                                          # => {"hello"=>1, "world"=>1}
sorted = uniq.sort_by { -_2 }                                  # => [["hello", 1], ["world", 1]]
took = sorted.take(25)                                         # => [["hello", 1], ["world", 1]]
puts took.map { |e| e * " - " }
# >> hello - 1
# >> world - 1
