## 歴史的スタイル ##

### 1. 古き良き時代 - アセンブリ言語 ###

# 限られたメモリしかなく、メモリはアドレスでのみで指定する

#+BEGIN_SRC
f = File.open("stop_words.txt", "r")
stop_words = f.read(1024).split(",")
f.close

data = []
data << nil
data << ""
data << nil
data << 0
data << false
data << ""
data << ""
data << 0
data << ""

if File.exist?("_word_freqs.txt")
  File.delete("_word_freqs.txt")
end
word_freqs = File.open("_word_freqs.txt", "wb+")
f = File.open("pride-and-prejudice.txt")
# f = File.open("input.txt")
while true
  data[1] = f.readline rescue ""
  if data[1] == ""
    break
  end
  if data[1][data[1].length - 1] != "\n"
    data[1] += "\n"
  end
  data[2] = nil
  data[3] = 0
  for data[8] in data[1].chars
    if data[2] == nil
      if data[8].match?(/\p{Alpha}/)
        data[2] = data[3]
      end
    else
      if data[8].match?(/\P{Alpha}/)
        data[4] = false
        data[5] = data[1][data[2]...data[3]].downcase
        if data[5].length >= 2 && !stop_words.include?(data[5])
          while true
            data[6] = word_freqs.readline.strip rescue ""
            if data[6] == ""
              break
            end
            data[7] = data[6].split(",")[1].to_i
            data[6] = data[6].split(",")[0].strip
            if data[5] == data[6]
              data[7] += 1
              data[4] = true
              break
            end
          end
          if !data[4]
            word_freqs.printf("%20s,%04d\n", data[5], 1)
          else
            word_freqs.pos -= 26
            word_freqs.printf("%20s,%04d\n", data[5], data[7])
          end
          word_freqs.pos = 0
        end
        data[2] = nil
      end
    end
    data[3] += 1
  end
end
f.close
word_freqs.flush

data.slice!(0..-1)

data = data + [[]] * (25 - data.length)
data << ""
data << 0
data << 0

while true
  data[25] = word_freqs.readline.strip rescue ""
  if data[25] == ""
    break
  end
  data[26] = data[25].split(",")[1].to_i
  data[25] = data[25].split(",")[0].strip
  data[27] = 0
  while data[27] < 25
    if data[data[27]] == [] or data[data[27]][1] < data[26]
      data.insert(data[27], [data[25], data[26]])
      data.pop
      break
    end
    data[27] += 1
  end
end

data[25] = 0
while true
  if data[25] >= 25
    break
  end
  if data[data[25]].length != 2
    break
  end
  puts "#{data[data[25]][0]} - #{data[data[25]][1]}"
  data[25] += 1
end

word_freqs.close
#+END_SRC

# 現代の言語がどれだけありがたいかわかる
