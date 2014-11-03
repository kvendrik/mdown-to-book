Present
=======
## A very minimalistic HTML presentation framework.

### How to use
1. Clone this repo and move into the folder `git clone https://github.com/kvendrik/Present.git && cd Present`
2. Run `grunt serve` to start a server on `127.0.0.1:9000`
3. Start customizing the slides' markup in `index.html` and modifing the styling of the theme and slides in `theme.scss` and `slides.scss`

#### Dev Dependencies
Present uses [grunt](http://gruntjs.com/) for its server, compiling SASS and concatting and uglifying JavaScript. In order to be able to use grunt you need to have the grunt-cli installed: `npm install -g grunt-cli`.

#### Grunt Tasks
* `serve` starts a server at `127.0.0.1:9000` and watches for changes.
    * When a JS file is changed the concat task will run and output `js/app.js`
    * When a SCSS file is changed the SASS will be compiled to `css/main.css`
* `build` compiles the SCSS files to `css/main.css` and uglifies the JS to `js/app.min.js`

### Creating slides

#### Markup
* HTML elements with the class `slide` are considered slides
* Within these slides you can use HTML elements with the class `step` to create steps

#### Styling
* `main.scss` contains the core styles
* `theme.scss` contains styling for the theme
* `slides.scss` contains styling for specific slides

#### Hotlinking
You can link to a specific slide and step by specifing them in the URL.
```
#slide-4&step-2
```
