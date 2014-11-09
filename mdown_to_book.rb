class MdownToBook

    def initialize(md_dir_path)
        @md_dir_path = md_dir_path

        #create output directory from template
        createOutputDir()

        #get settings (merge defaults and user settings)
        settings = getSettings()

        #get html contents
        html_parts = getHtmlParts()
        parsed_html = parseTagsInHtmlParts(html_parts, settings)

        #write file with contents
        writeOutputToFile(parsed_html)
    end

private

    def createOutputDir()
        #create dir
        output_dir = @md_dir_path+'/book-output'
        FileUtils.mkdir_p(output_dir)

        #copy templates files to output dir
        FileUtils.cp_r(Dir.glob('template/*'), output_dir)
    end

    def getSettings()
        #store user settings file path
        user_settings_file_path = @md_dir_path+'/book-settings.json'

        #check if user settings exist
        if File.exist?(user_settings_file_path)
            #get user settings
            settings_string = File.open(user_settings_file_path, "rb")
            settings = JSON.parse(settings_string.read)

            #get defaults
            defaults_string = File.open('default-settings.json', "rb")
            defaults = JSON.parse(defaults_string.read)

			# automate settings checking for single depth parameters
			setting_list = ['title','footer','contents-table']
			setting_list.each do |check_setting|
				if settings[check_setting].nil?
                    settings[check_setting] = defaults[check_setting]
            	end
			end

			# buttons are multi dimensional arrays, this will be parsed loose
            if settings['buttons']['previous'].nil?
                    settings['buttons']['previous'] = defaults['buttons']['previous']
            end
            if settings['buttons']['next'].nil?
                    settings['buttons']['next'] = defaults['buttons']['next']
            end

            return settings
        else
            s = File.open('default-settings.json', "rb")
            return JSON.parse(s.read)
        end

    end

    def writeOutputToFile(output)
        outfile = File.new @md_dir_path+'/book-output/book/index.html',"w"
        outfile.puts(output);
        outfile.close;
        puts 'File written to ' + @md_dir_path + '/book-output/book';
    end

    def parseTagsInHtmlParts(html_parts, settings)
        #open and store current index.html contents
        file_string = File.open(@md_dir_path+'/book-output/book/index.html', "rb")
        file_contents = file_string.read

        #replace tags with config options in file
        file_contents['{{TITLE}}'] = settings['title']
        file_contents['{{FOOTER}}'] = settings['footer']
        file_contents['{{BUTTONPREV}}'] = settings['buttons']['previous']
        file_contents['{{BUTTONNEXT}}'] = settings['buttons']['next']

        cover = '<section class="page cover">'+html_parts[:cover]+'</section>'
        page_index = '<section class="page index"><h2>'+settings['contents-table']+'</h2><table>'+html_parts[:index]+'</table></section>'
        file_contents['{{PAGES}}'] = cover+page_index+html_parts[:base]

        return file_contents
    end

    def getHtmlParts()
        html_parts = {
            :base => '',
            :cover => '',
            :index => ''
        }

        curr_file_idx = 1
        md_parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

        md_paths = Dir.glob(@md_dir_path+'/*.md').sort_by {|filename| filename.match(/(\d+(\.\d+)?)\_.+/)[1].to_f}

        #get and loop md files, parse and store their HTML contents
        md_paths.each do |curr_file_path|

            # log current file
            puts 'Parsing '+curr_file_path+'...'

            # open file
            file = File.open(curr_file_path, "rb")

            #if first file
            if curr_file_idx == 1
                #parse md and store as cover
                html_parts[:cover] = md_parser.render(file.read)
                # increase the current file index to match the index page
                curr_file_idx += 1
            else
                #parse markdown
                contents = md_parser.render(file.read)

                #replace images with lightbox
                contents = contents.gsub(/\<img\ ?(\w{0,5})\=\"([^\"]+)\"\ ?(\w{0,5})\=\"([^\"]+)\"\ ?(\w{0,5})\=\"([^\"]+)\"\ ?\/?\>/, "<div class='enlarge'><img src='\\2' alt='\\4'></div><cite>\\6</cite>")

                #append page to output
                html_parts[:base] += '<div class="page" id="page-'+curr_file_idx.to_s+'">'+ contents +'</div>'

                #remove path to files from str
                curr_file_path[@md_dir_path] = ''

                #remove extention
                curr_file_path['.md'] = ''

                #get chapter number and name
                result = curr_file_path.match(/(\d(\.\d)?)\_(.+)/)

                #if is a subchapter
                tr_class = result[2] ? ' class="sub-page"' : '';

                #store page index html
                html_parts[:index] += '<tr'+tr_class+'><td><a href="?page='+curr_file_idx.to_s+'">'+result[3]+'</a></td><td><a href="?page='+curr_file_idx.to_s+'">'+curr_file_idx.to_s+'</a></td></tr>'
            end

            #update curr file idx
            curr_file_idx += 1
        end

        return html_parts
    end

end