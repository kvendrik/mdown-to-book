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

markdown    = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

#Check the folder to obtain .md files from
read_folder  = ARGV[0]

options = {}
OptionParser.new do |opts|
		opts.banner = "Usage: parse.rb [options]"

		opts.on("-v", "--verbose", "Run verbosely") do |v|
			puts options[:verbose] = v
		end
end.parse!


class MdownToBook

	def initialize(file_path)
		@output_html = {
			:base => ''
			:cover => ''
			:index => ''
		}

		@curr_file_idx = 0
		@defaults = false
		@file_path = file_path

		createOutputDir()

		settings = getSettings()

		#read folder and put contens in the right strings and array's
		Dir.glob(file_path+'/*.md') do |rb_file|
				puts rb_file
				file = File.open(rb_file, "rb")
				if i == 0
						cover = markdown.render(file.read)
				else
						contents = markdown.render(file.read)
						contents = contents.gsub(/\<img\ ?(\w{0,5})\=\"([^\"]+)\"\ ?(\w{0,5})\=\"([^\"]+)\"\ ?(\w{0,5})\=\"([^\"]+)\"\ ?\/?\>/, "
																				<div class='enlarge'>
																						<img src='\\2' alt='\\4'>
																				</div>
																				<cite>\\6</cite>")
						output = output + '<div class="page" id="page-'+i.to_s+'">' + contents + '</div>'

						# compose page index
						rb_file[read_folder] = ''
						rb_file['.md'] = ''
						result = rb_file.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '\1')
						page_index += '<tr><td><a href="?page='+i.to_s+'">'+result+'</a></td><td><a href="?page='+i.to_s+'">'+i.to_s+'</a></td></tr>'
				end
				i+=1
		end

		file = File.open(file_path+'/book-output/book/index.html', "rb")
		temp = file.read

		if !defaults
				d = File.open('default-settings.json', "rb")
				defaults = JSON.parse(d.read)
				if settings['title'].nil?
						settings['title'] = defaults['title']
				end
				 if settings['footer'].nil?
						settings['footer'] = defaults['footer']
				end
				 if settings['buttons']['previous'].nil?
						settings['buttons']['previous'] = defaults['buttons']['previous']
				end
				if settings['buttons']['next'].nil?
						settings['buttons']['next'] = defaults['buttons']['next']
				end
				if settings['contents-table'].nil?
						settings['contents-table'] = defaults['contents-table']
				end
		end

		t_title  = settings['title']
		t_footer  = settings['footer']
		t_btnpr  = settings['buttons']['previous']
		t_btnne  = settings['buttons']['next']
		t_contents = settings['contents-table']

		temp['{{TITLE}}']   = t_title
		temp['{{FOOTER}}']  = t_footer
		temp['{{BUTTONPREV}}']  = t_btnpr
		temp['{{BUTOTNNEXT}}']  = t_btnne

		cover       = '<section class="page cover">' + cover + '</section>'
		page_index   = '<section class="page index"><h2>'+t_contents+'</h2><table>' + page_index + '</table></section>'

		temp['{{PAGES}}']   = cover+page_index+output

		outfile = File.new file_path+'/book-output/book/index.html',"w"
		outfile.puts(temp);
		outfile.close;
		puts 'File written to ' + file_path + '/book-output/book';
	end

private

	def createOutputDir(){
		# create dir
		output_dir = @file_path+'/book-output'
		FileUtils.mkdir_p(output_dir)

		# copy files
		FileUtils.cp_r(Dir.glob('template/*'), output_dir)
	}

	def getSettings(){
		# set config file
		conf_file = @file_path+'/book-settings.json'
		if File.exist?(conf_file)
				s = File.open(conf_file, "rb")
		else
				s = File.open('default-settings.json', "rb")
				defaults = true
		end

		return JSON.parse(s.read)
	}

end
