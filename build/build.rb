require 'rio'

source        = rio('../Source')
packer        = 'C:\Program Files\SmallSharpTools.com\Packer\bin\Packer.exe'
rar           = 'C:/Program Files/WinRAR/rar.exe'

build         = rio('dp.SyntaxHighlighter').rmtree.mkpath
scripts       = rio(build, 'Scripts').mkpath
styles        = rio(build, 'Styles').mkpath
uncompressed  = rio(build, 'Uncompressed').mkpath

rio(source, 'Scripts').each do |file|
  next if file =~ /\.svn/
  
  puts "Copied %s" % file.filename

  file > scripts
  next if not file.ext? =~ /\.js/
  
  file > uncompressed
  
  file = rio(scripts, file.filename.to_s)
  name = file.to_s
  file.rename!("#{file}.tmp")
  
  `"#{packer}" -o "#{name}" -m jsmin "#{file}"`
  file.delete
end

rio(source, 'Styles/SyntaxHighlighter.css') > styles

puts `"#{rar}" a SyntaxHighlighter.rar #{build}`
build.rmtree
