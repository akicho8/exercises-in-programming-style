$stack = []
$heap = {}

def read_file
  $stack.push(IO.read($stack.pop))
end

def filter_chars
  $stack.push(/[\W_]+/)
  str, re = $stack.pop(2)
  $stack.push(str.gsub(re, " ").downcase)
end

def scan
  $stack.push(*$stack.pop.split)
end

def remove_stop_words
  $stack.push(IO.read("../stop_words.txt").scan(/\w+/))
  $stack.last.concat([*"a".."z"])
  $heap[:stop_words] = $stack.pop

  $heap[:words] = []
  while !$stack.empty?
    if $heap[:stop_words].include?($stack.last)
      $stack.pop
    else
      $heap[:words].push($stack.pop)
    end
  end

  $stack.push(*$heap[:words])

  $heap.delete(:stop_words)
  $heap.delete(:words)
end

def frequencies
  $heap[:word_freqs] = {}
  while !$stack.empty?
    if count = $heap[:word_freqs][$stack.last] # count = word_freqs["foo"] # => 
      $stack.push(count)                       # [5]
      $stack.push(1)                           # [5, 1]
      $stack.push($stack.pop + $stack.pop)     # [6]
    else
      $stack.push(1)
    end
    key, count = $stack.pop(2)
    $heap[:word_freqs][key] = count            # word_freqs["foo"] = 6
  end
  $stack.push($heap[:word_freqs])
  $heap.delete(:word_freqs)
end

def sort
  $stack.push(*$stack.pop.sort_by { _2 })
end

$stack.push("../pride-and-prejudice.txt")
read_file
filter_chars
scan
remove_stop_words
frequencies
sort

$stack.push(0)
while $stack.last < 25 && $stack.size > 1
  $heap[:i] = $stack.pop
  w, f = $stack.pop
  puts "#{w} - #{f}"
  $stack.push($heap[:i])
  $stack.push(1)
  $stack.push($stack.pop + $stack.pop)
end
