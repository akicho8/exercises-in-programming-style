def frequencies(words)
  words.tally.sort_by { -_2 }.take(25)
end
