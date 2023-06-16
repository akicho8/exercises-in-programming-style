require "open3"
require "pathname"
files = Pathname.glob("**/*.{rb,py}").find_all { |e| e.basename.to_s.match?(/tf\-\d+/) }
files -= [Pathname("07-code-golf/tf-07.rb")]
files.each do |file|
  if file.dirname.to_s.match?(/^\d/)
    system "cp #{file} ruby"
  end
end
