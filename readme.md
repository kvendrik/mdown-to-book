Markdown to book
=================
A command line tool that parses a folder of markdown files into a digital book

## Dependencies
* [Redcarpet](https://github.com/vmg/redcarpet)
* [JSON](http://www.ruby-doc.org/stdlib-2.0/libdoc/json/rdoc/JSON.html)

## Usage

### Simple usage
1. Clone this repository and `cd` into it `git clone http://github.com/kvendrik/mdown-to-book.git && cd mdown-to-book`
2. Install the dependencies: `sudo gem install redcarpet json`
3. Make sure the current [file order](#file-order) of your markdown files represents the structure for the book.
4. *(Optional) Create a [`book-settings.json`](#book-settingsjson) file in the directory with your markdown files.*
5. Run `ruby parse.rb <path to your markdown files>`
6. You can find the book in `<path to your markdown files>/book-output/book/`

### Customizing the theme
1. `cd` into the output directory `cd <path to your markdown files>/book-output/`
2. Run `npm install` to install all the needed dependencies to customize the theme
3. Run `grunt serve` (make sure you have the [grunt-cli](http://gruntjs.com/getting-started) installed)
4. A new browser tab will open. You can now start modifying the theme while Grunt takes care of the rest. (pre-processing SASS, merging JS files, etc.)

### File order
Each file will be parsed to a new page in your book and will be considered a chapter. The filename will be used as the name for that chapter. To create the desired order you prepend your filenames with numbers e.g. `1_Chapter 1.md`. The first file in the folder will be used as cover page. We automatically generate a table of contents based on the chapters.

### book-settings.json
The `book-settings.json` file accepts the options below. In case the `book-settings.json` file could not be found or one of the options is not defined the script uses default values to fill in the blanks.

|Option|Type|Description|
|:---|:---|:---|
|title|String|The title for your book|
|contents-table|String|Text to use as title for the table of contents|
|footer|String|The footer text to appear on the bottom of every page|
|buttons|Object|Accepts a `next` and a `previous` option that each take a string to use as text on the navigation buttons|

### Images
In your markdown you can reference images by using `img/<image filename>`. Then after you parsed your book you can place the images in `<path to your markdown files>/book-output/book/img/`