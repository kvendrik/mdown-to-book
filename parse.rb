## Markdown to book, kvendrik && Matti van de Weem
#
#  @project Markdown to book
#  @author  Matti van de Weem
#  @date    November 2014
#  @url     http://github.com/kvendrik/mdown-to-book/
#
## make sure you installed the red carpet gem && json



#dependancies
require 'rubygems'
require 'redcarpet'
require 'fileutils'
require 'json'

markdown    = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

#Check the folder to obtain .md files from
readFolder  = ARGV[0]

#defaults
output      = '';
cover       = '';
pageIndex   = '';
i           = 0;

# iniate the template to copy
FileUtils.cp_r(Dir.glob('template'), readFolder)
s = File.open(readFolder+'/book-settings.json', "rb");
settings = JSON.parse(s.read);

#read folder and put contens in the right strings and array's
Dir.glob(readFolder+'/*.md') do |rb_file|
    puts rb_file;
    file = File.open(rb_file, "rb")
    if i == 0
        cover = markdown.render(file.read)
    else
        contents = file.read
        output = output + '<div class="page" id="page-'+i.to_s+'">' + markdown.render(contents) + '</div>'

        #compose the page index
        pageIndex += '<tr><td><a href="?page='+i.to_s+'">'+rb_file+'</a></td><td><a href="?page='+i.to_s+'">'+i.to_s+'</a></td></tr>'
    end
    i = i + 1
end

file = File.open(readFolder+'/template/book/index.html', "rb")
temp = file.read

cover       = '<section class="page cover">' + cover + '</section>'
pageIndex   = '<section class="page index"><h2>'+settings['contents-table']+'</h2><table>' + pageIndex + '</table></section>';

temp['{{PAGES}}']   = cover+pageIndex+output;
temp['{{TITLE}}']   = settings['title'];
temp['{{FOOTER}}']  = settings['footer'];
temp['{{BUTTONPREV}}']  = settings['buttons']['previous'];
temp['{{BUTOTNNEXT}}']  = settings['buttons']['next'];

#output content to given file, and puts some text to the terminal
outfile = File.new readFolder+'/template/book/index.html',"w"
outfile.puts(temp);
outfile.close;
puts 'File written to ' + readFolder + '/book';
