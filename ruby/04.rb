word_freqs = []
stop_words = File.read("../stop_words.txt").split(",")
stop_words.concat([*"a".."z"])

File.open("../pride-and-prejudice.txt") do |f|
  f.each_line do |line|
    start_char = nil
    line.each_char.with_index do |c, i|
      if !start_char
        if c.match?(/\p{Alpha}/)
          start_char = i
        end
      else
        if c.match?(/\P{Alpha}/)
          found = false
          word = line[start_char...i].downcase
          unless stop_words.include?(word)
            pair_index = 0
            word_freqs.each do |pair|
              if word == pair[0]
                pair[1] += 1
                found = true
                break
              end
              pair_index += 1
            end
            if !found
              word_freqs << [word, 1]
            elsif !word_freqs.empty?
              pair_index.pred.downto(0) do |n|
                if word_freqs[pair_index][1] > word_freqs[n][1]
                  word_freqs[n], word_freqs[pair_index] = word_freqs[pair_index], word_freqs[n]
                  pair_index = n
                end
              end
            end
          end
          start_char = nil
        end
      end
    end
  end
end

word_freqs.take(25).each do |a, b|
  puts "#{a} - #{b}"
end
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
