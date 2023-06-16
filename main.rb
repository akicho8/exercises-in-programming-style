frequency = File.read("input.txt").scan(/\w+/).collect(&:downcase).tally
frequency = frequency.except("in", "the").sort_by { |_, count| -count }.take(25)
puts frequency.collect { |word, count| [word, count].join(" - ") }
# >> live - 2
# >> mostly - 2
# >> india - 1
# >> wild - 1
# >> lions - 1
# >> white - 1
# >> africa - 1
# >> tigers - 1
