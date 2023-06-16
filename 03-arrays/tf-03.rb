# require 'numo/narray'
# 
# a = Numo::NArray["A", "B"]      # => Numo::RObject#shape=[2]
# a.to_a                          # => ["A", "B"]
# p Numo::Char                    # => 
# # b = Numo::NArray.to_array(Numo::Char.downcase(characters))
# # exit
# exit
# 
# 
# 
# 
# 
# 
# 
# chars = File.read('../input.txt').chars
# characters = Numo::NArray[" ", *chars, " "]
# 
# characters[~Numo::Bit.true?(characters =~ /[[:alpha:]]/)] = ' '
# 
# p characters
# exit
# 
# 
# 
# 
# characters = Numo::NArray.to_array(Numo::Char.downcase(characters))
# # Result: [' ', 'h', 'e', 'l', 'l', 'o', ' ', ' ',
# #           'w', 'o', 'r', 'l', 'd', ' ', ' ']
# 
# ### Split the words by finding the indices of spaces
# sp = Numo::NArray.where(characters == ' ')
# # Result: [ 0, 6, 7, 13, 14]
# # A little trick: let's double each index, and then take pairs
# sp2 = Numo::NArray.repeat(sp, 2)
# # Result: [ 0, 0, 6, 6, 7, 7, 13, 13, 14, 14]
# # Get the pairs as a 2D matrix, skip the first and the last
# w_ranges = Numo::NArray.reshape(sp2[1..-2], [-1, 2])
# # Result: [[ 0,  6],
# #                [ 6,  7],
# #                [ 7, 13],
# #                [13, 14]]
# # Remove the indexing to the spaces themselves
# w_ranges = w_ranges[w_ranges[true, 1] - w_ranges[true, 0] > 2]
# # Result: [[ 0,  6],
# #                [ 7, 13]]
# 
# # Voila! Words are in between spaces, given as pairs of indices
# words = w_ranges.map {|r| characters[r[0]...r[1]].to_a }
# # Result: [[' ', 'h', 'e', 'l', 'l', 'o'],
# #          [' ', 'w', 'o', 'r', 'l', 'd']]
# # Let's recode the characters as strings
# swords = Numo::NArray.to_array(words).map(&:join).map(&:strip)
# # Result: ['hello', 'world']
# 
# # Next, let's remove stop words
# stop_words = File.read('../stop_words.txt').split(',').uniq
# ns_words = swords.reject {|w| stop_words.include?(w)}
# 
# ### Finally, count the word occurrences
# uniq, counts = ns_words.uniq, ns_words.counts
# wf_sorted = uniq.to_a.zip(counts.to_a).sort_by {|_, c| -c }
# 
# wf_sorted.first(25).each {|w, c| puts "#{w} - #{c}" }
# # ~> -:5:in `<main>': uninitialized constant Numo::Char (NameError)
