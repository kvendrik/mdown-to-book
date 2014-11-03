Markdown to book
=================

Requires [RedCarpet](https://github.com/vmg/redcarpet)

## Starting off
 - include all your markdown files into the mdown folder.
 - run `ruby parse.ru [folder to read] [file to output]` from ternminal*.
 - files will be saved in output.html

## Usage

### Parsing
1. Clone this repository and cd into it
```
git clone http://github.com/kvendrik/mdown-to-book.git && cd mdown-to-book
```
2. Make sure you have a `book-settings.json` file in the directory with your markdown files. Also make sure the current file order in that directory represents the structure for the book.
3. Run `ruby parse.ru --path=<path to your markdown files>`

### Styling
1. `cd` into the output directory `cd <path to your markdown files>/book-output/`
2. Run `grunt serve` (make sure you have the [grunt-cli](http://gruntjs.com/getting-started) installed)
3. A new browser tab will open. You can now start modifying the template while Grunt takes care of the rest. (pre-processing SASS, merging JS files, etc.)

### File structure
Each file will be parsed to a new page in your book and will be considered a chapter. The filename will be used as the name for that chapter. To create the desired order we recommand you prepend your filenames with numbers e.g. `1. Chapter 1`. The first file in the folder will be used as cover page. We automatically generate a table of contents based on the chapters.

### `book-settings.json`
The `book-settings.json` file accepts the following options:

|Option|Type|Description|Required|
|:---|:---|:---|:---|
|title|String|The title for your book|No|
|footer|String|The footer text to appear on the bottom of every page|No|
|buttons|Object|Accepts a `next` and a `previous` option that each take a string to use as text on the navigation buttons|No|
