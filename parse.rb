## Markdown to book, kvendrik && Matti van de Weem
#
#  @project Markdown to book
#  @author  Matti van de Weem<mvdweem@gmail.com>
#  @date    November 2014
#  @url     http://github.com/kvendrik/mdown-to-book/
#
## ~to start : ruby parse.rb mdown

#dependancies
require 'rubygems'
require 'redcarpet'
require 'fileutils'
require 'json'
require 'optparse'
require_relative 'mdown_to_book.rb'

#Check the folder to obtain .md files from
read_folder  = ARGV[0]

options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: parse.rb [options] [path to markdown files]"
end.parse!

MdownToBook.new(ARGV[0])
