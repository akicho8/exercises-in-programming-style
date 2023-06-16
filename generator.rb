TITLE_INFO = {
  "01" => { :name1 => "a", :name2 => "b", },
  "04" => { :name1 => "a", :name2 => "b", },
  "05" => { :name1 => "a", :name2 => "b", },
  "07" => { :name1 => "a", :name2 => "b", },
}

require "pathname"

files = Pathname.glob("**/*.rb").find_all { |e| e.basename.to_s.match?(/tf\-\d+/) }
files -= [Pathname("07-code-golf/tf-07.rb")]
puts files
body = files.collect { |file|
  source = file.read
  source = source.gsub(/# >> mr - 786.*/m, "")
  id = file.dirname.to_s.slice(/\d+/)
  title_info = TITLE_INFO.fetch(id)
  title = [title_info[:name1], title_info[:name2]].join(" - ")
  out = []
  out << "## #{title} ##"
  out << ""
  out << "```ruby"
  out << source.strip
  out << "```"
  out
}.join("\n")
# puts body
