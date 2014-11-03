require 'rubygems'
require 'redcarpet'

output      = ''
i           = 0;
markdown    = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

Dir.glob('mdown/*.md') do |rb_file|
    file = File.open(rb_file, "rb")
    contents = file.read
    output = output + '<div id="page-'+i.to_s+'">' + markdown.render(contents) + '</div>'
    i = i + 1;
end

outfile = File.new "output.html","w"
outfile.puts(output);
outfile.close;
puts output;