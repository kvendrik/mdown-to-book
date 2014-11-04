class MdownToBook

    def initialize(md_dir_path)
        @output_html = {
            :base => '',
            :cover => '',
            :index => ''
        }

        @curr_file_idx = 0
        @md_dir_path = md_dir_path
        @md_parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

        #create output directory from template
        createOutputDir()

        #get settings from json
        @settings = getSettings()

        #get html contents
        html_content = getHtmlContents()

        #write file with contents
        writeOutputToFile(html_content)
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

            #replace defaults with defined user options
            if settings['title'].nil?
                    settings['title'] = defaults['title']
            end
            if settings['footer'].nil?
                    settings['footer'] = defaults['footer']
            end
            if settings['contents-table'].nil?
                    settings['contents-table'] = defaults['contents-table']
            end

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

    def getHtmlContents()
        #get md files
        Dir.glob(@md_dir_path+'/*.md') do |curr_file_path|

            # log current file
            puts 'Parsing '+curr_file_path+'...'

            # open file
            file = File.open(curr_file_path, "rb")

            #if first file
            if @curr_file_idx == 0
                #parse md and store as cover
                @output_html[:cover] = @md_parser.render(file.read)
            else
                #parse markdown
                contents = @md_parser.render(file.read)

                #replace images with lightbox
                contents = contents.gsub(/\<img\ ?(\w{0,5})\=\"([^\"]+)\"\ ?(\w{0,5})\=\"([^\"]+)\"\ ?(\w{0,5})\=\"([^\"]+)\"\ ?\/?\>/, "
                                                                            <div class='enlarge'>
                                                                                    <img src='\\2' alt='\\4'>
                                                                            </div>
                                                                            <cite>\\6</cite>")

                #append page to output
                @output_html[:base] += '<div class="page" id="page-'+@curr_file_idx.to_s+'">' + contents + '</div>'

                #remove path to files from str
                curr_file_path[@md_dir_path] = ''

                #remove extention
                curr_file_path['.md'] = ''

                #remove prepended file number (e.g. 1_)
                result = curr_file_path.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '')

                #store page index html
                @output_html[:index] += '<tr><td><a href="?page='+@curr_file_idx.to_s+'">'+result+'</a></td><td><a href="?page='+@curr_file_idx.to_s+'">'+@curr_file_idx.to_s+'</a></td></tr>'
            end

            #update curr file idx
            @curr_file_idx += 1
        end

        #open and store index.html contents
        file = File.open(@md_dir_path+'/book-output/book/index.html', "rb")
        file_contents = file.read

        settings = @settings

        #replace tags with config options in file
        file_contents['{{TITLE}}']   = settings['title']
        file_contents['{{FOOTER}}']  = settings['footer']
        file_contents['{{BUTTONPREV}}']  = settings['buttons']['previous']
        file_contents['{{BUTOTNNEXT}}']  = settings['buttons']['next']

        cover = '<section class="page cover">' + @output_html[:cover] + '</section>'
        page_index = '<section class="page index"><h2>'+settings['contents-table']+'</h2><table>' + @output_html[:index] + '</table></section>'
        file_contents['{{PAGES}}'] = cover+page_index+@output_html[:base]

        return file_contents
    end

end