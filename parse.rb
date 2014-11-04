## Markdown to book, kvendrik && Matti van de Weem
#
#  @project Markdown to book
#  @author  Matti van de Weem
#  @date    November 2014
#  @url     http://github.com/kvendrik/mdown-to-book/
#
## ~to start : ruby parse.ru mdown



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
defaults    = false;

# iniate the template to copy
directory = readFolder+'/book-output';
FileUtils.mkdir_p(directory);


FileUtils.cp_r(Dir.glob('template/*'), readFolder+'/book-output')
setfile = readFolder+'/book-settings.json';


if File.exist?(setfile)
    s = File.open(setfile, "rb");
else
    s = File.open('default-settings.json', "rb");
    defaults = true;
end

settings = JSON.parse(s.read);

#read folder and put contens in the right strings and array's
Dir.glob(readFolder+'/*.md') do |rb_file|
    puts rb_file;
    file = File.open(rb_file, "rb")
    if i == 0
        cover = markdown.render(file.read)
    else
        contents = markdown.render(file.read);
        contents = contents.gsub(/\<img\ ?(\w{0,5})\=\"([^\"]+)\"\ ?(\w{0,5})\=\"([^\"]+)\"\ ?(\w{0,5})\=\"([^\"]+)\"\ ?\/?\>/, "
                                    <div class='enlarge'>
                                        <img src='\\2' alt='\\4'>
                                    </div>
                                    <cite>\\6</cite>")
        output = output + '<div class="page" id="page-'+i.to_s+'">' + contents + '</div>'

        # compose page index
        rb_file[readFolder] = '';
        rb_file['.md'] = '';
        result = rb_file.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '\1')
        pageIndex += '<tr><td><a href="?page='+i.to_s+'">'+result+'</a></td><td><a href="?page='+i.to_s+'">'+i.to_s+'</a></td></tr>'
    end
    i+=1
end

file = File.open(readFolder+'/book-output/book/index.html', "rb")
temp = file.read

if !defaults
    d = File.open('default-settings.json', "rb");
    defaults = JSON.parse(d.read);
    if settings['title'].nil?
        settings['title'] = defaults['title'];
    end
     if settings['footer'].nil?
        settings['footer'] = defaults['footer'];
    end
     if settings['buttons']['previous'].nil?
        settings['buttons']['previous'] = defaults['buttons']['previous'];
    end
    if settings['buttons']['next'].nil?
        settings['buttons']['next'] = defaults['buttons']['next'];
    end
    if settings['contents-table'].nil?
        settings['contents-table'] = defaults['contents-table'];
    end
end

t_title  = settings['title'];
t_footer  = settings['footer'];
t_btnpr  = settings['buttons']['previous'];
t_btnne  = settings['buttons']['next'];
t_contents = settings['contents-table'];

temp['{{TITLE}}']   = t_title
temp['{{FOOTER}}']  = t_footer
temp['{{BUTTONPREV}}']  = t_btnpr
temp['{{BUTOTNNEXT}}']  = t_btnne

cover       = '<section class="page cover">' + cover + '</section>'
pageIndex   = '<section class="page index"><h2>'+t_contents+'</h2><table>' + pageIndex + '</table></section>';

temp['{{PAGES}}']   = cover+pageIndex+output;

outfile = File.new readFolder+'/book-output/book/index.html',"w"
outfile.puts(temp);
outfile.close;
puts 'File written to ' + readFolder + '/book-output/book';
