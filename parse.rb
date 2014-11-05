## Markdown to book, kvendrik && Matti van de Weem
#
#  @project Markdown to book
#  @author  Matti van de Weem <mvdweem@gmail.com>, Koen Vendrik <k.vendrik@gmail.com>
#  @date    November 2014
#  @url     http://github.com/kvendrik/mdown-to-book/
#
## ~to start : ruby parse.rb <path to markdown files>

#dependancies
require 'rubygems'
require 'redcarpet'
require 'fileutils'
require 'json'
require 'optparse'
require_relative 'mdown_to_book.rb'

#Check the folder to obtain .md files from
read_folder  = ARGV[0]
if !read_folder
  raise 'please enter the path to your markdown files'
end

options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: parse.rb [options] [path to markdown files]"
end.parse!

MdownToBook.new(read_folder)
