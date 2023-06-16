# typed: strict
require "open3"
require "pathname"
files = Pathname.glob("*.rb").find_all { |e| e.basename.to_s.match?(/^\d+{2}\./) }
files.each do |file|
  stdout, stderr, status = Open3.capture3("time ruby #{file.basename}", chdir: file.dirname)
  success = stdout.include?("mr - 786") ? "o" : "x"
  puts [file.basename.to_s.slice(/\d+/), "%.2f" % stderr.to_f, success, file.to_s].inspect
end
