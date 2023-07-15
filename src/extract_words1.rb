def extract_words(path_to_file)
  words = IO.read(path_to_file).downcase.scan(/[a-z]{2,}/)
  stop_words = IO.read("stop_words.txt").scan(/\w+/)
  words - stop_words
end
