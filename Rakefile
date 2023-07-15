task :default => :generate

task :generate do
  system "sh", "-vec", <<~EOT, exception: true
~/src/source2md/.bin/source2md generate --xmp-out-exclude --no-debug -o ~/src/zenn-content/articles/33e46f78a073bf.md src/[0-9]*
EOT
end

task :open do
  system "sh", "-vec", <<~EOT, exception: true
open https://zenn.dev/megeton/articles/33e46f78a073bf
EOT
end

task :renum do
  raise NotImplementedError, "#{__method__} is not implemented"
end

task :test do
  require "open3"
  require "pathname"
  Pathname.glob("src/[0-9]*.rb") do |file|
    stdout, stderr, status = Open3.capture3("time ruby #{file.basename}", chdir: file.dirname)
    result = stdout.include?("mr - 786") ? "o" : "x"
    puts [result, file.basename(".*").to_s, ("%.2f" % stderr.to_f)] * " "
  end
end
