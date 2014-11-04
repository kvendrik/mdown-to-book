## Markdown to book, kvendrik && Matti van de Weem
#
#  @project Markdown to book
#  @author  Matti van de Weem
#  @date    November 2014
#  @url     http://github.com/kvendrik/mdown-to-book/
#
## make shure you installed the red carpet gem



#dependancies
require 'rubygems'
require 'redcarpet'

markdown    = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

#Check the folder to obtain .md files from
readFolder  = ARGV[0]

#Define the file to output to
putFile     = ARGV[1]

#defaults
output      = ''
i           = 0;
menu        = Array.new;

#read folder and put contens in the right strings and array's
Dir.glob(readFolder+'/*.md') do |rb_file|
    puts rb_file;
    menu.push(rb_file);
    file = File.open(rb_file, "rb")
    contents = file.read
    output = output + '<div id="page-'+i.to_s+'">' + markdown.render(contents) + '</div>'
    i = i + 1;
end

#output content to given file, and puts some text to the terminal
outfile = File.new putFile,"w"
outfile.puts(output);
outfile.close;
puts 'File written to ' + putFile;