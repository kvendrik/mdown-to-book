module.exports = function (grunt){

     grunt.initConfig({

        pkg: grunt.file.readJSON('package.json'),

        appRoot: 'app',

		connect: {
			server: {
				options: {
					livereload: true,
					hostname: '127.0.0.1',
					port: 9000,
					base: '<%= appRoot %>/'
				}
			}
		},

		open: {
			all: {
				path: 'http://localhost:<%= connect.server.options.port %>'
			}
		},

		watch: {
			options: {
			    livereload: true,
			},
		  	html: {
				files: ['<%= appRoot %>/*.html']
		  	},
		  	js: {
		  		files: ['<%= appRoot %>/js/src/*.js'],
		  		tasks: ['concat']
		  	},
		  	sass: {
		  		files: ['<%= appRoot %>/sass/*.scss'],
		  		tasks: ['sass']
		  	}
		},

		sass: {
			dist: {
			  files: {
			    '<%= appRoot %>/css/main.css': '<%= appRoot %>/sass/main.scss'
			  }
			}
		},

		concat: {
			options: {
			  separator: '\n\n',
			},
			js: {
			  src: ['<%= appRoot %>/fonts/ss-pika/ss-pika.js', '<%= appRoot %>/js/libs/*.js', '<%= appRoot %>/js/src/*.js'],
			  dest: '<%= appRoot %>/js/app.js'
			}
		},

		uglify: {
			js: {
			  files: {
			    '<%= appRoot %>/js/app.min.js': ['<%= appRoot %>/fonts/ss-pika/ss-pika.js', '<%= appRoot %>/js/libs/*.js', '<%= appRoot %>/js/src/*.js']
			  }
			}
		}

     });

     require('load-grunt-tasks')(grunt);

     grunt.registerTask('serve', ['connect', 'open', 'watch']);
     grunt.registerTask('build', ['sass', 'uglify']);
}