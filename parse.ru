#dependancies
require 'rubygems'
require 'redcarpet'

markdown    = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

#Check the folder to obtain .md files from
readFolder  = ARGV[0]
if readFolder.length == 0
    readFolder = 'mdown';
end

#Define the file to output to
putFile     = ARGV[1]
if putFile.length == 0
    putFile = 'output.html';
end

#defaults
output      = ''
i           = 0;

#read folder
Dir.glob(readFolder+'/*.md') do |rb_file|
    puts rb_file;
    file = File.open(rb_file, "rb")
    contents = file.read
    output = output + '<div id="page-'+i.to_s+'">' + markdown.render(contents) + '</div>'
    i = i + 1;
end

#output
outfile = File.new putFile,"w"
outfile.puts(output);
outfile.close;
puts 'File written to ' + putFile;