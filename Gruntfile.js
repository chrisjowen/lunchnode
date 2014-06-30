'use strict';
 module.exports = function (grunt) {
 // Project configuration.
 grunt.loadNpmTasks('grunt-contrib-copy');
 grunt.loadNpmTasks('grunt-contrib-watch');
 grunt.loadNpmTasks('grunt-exec');
 grunt.loadNpmTasks('grunt-concurrent');
 grunt.loadNpmTasks('grunt-contrib-coffee');
 grunt.loadNpmTasks('grunt-contrib-sass');
 grunt.loadNpmTasks('grunt-express-server');
 grunt.loadNpmTasks( "grunt-supervisor" );

 grunt.initConfig({
    
    concurrent: {
        server: {
            tasks: [ 'watch', 'supervisor:express'],
            options: {
                logConcurrentOutput : true,
                limit: 6
            }
        }
    },

    watch: {
        html: {
            files: ['src/angular/**/*.html', 'src/angular/app/*.html'],
            tasks: ['copy:html']
        },
        coffee: {
            files: ['src/angular/lib/*.coffee','src/angular/app/**/*.coffee','src/angular/app/app.coffee'],
            tasks: ['coffee:ui']
        },
        coffeeApi: {
            files: ['src/express/*.coffee','src/express/**/*.coffee'],
            tasks: ['coffee:api']
        },
        sass : {
            files: ['src/angular/sass/*.scss'],
            tasks: ['sass:dist']
        }
//        reload: {
//            files: ['dist/api/*.*','dist/api/**/*.*'],
//            options: {
//                livereload: true,
//                nospawn: false
//            }
//        }

    },
     
    copy: {
      html: {
        files: [
          // includes files within path
          {cwd:'src/angular/sass', expand: true, src: ['template/*'], dest: 'dist/ui/css'},
          {cwd:'src/angular/', expand: true, src: ['images/*'], dest: 'dist/ui/'},
          {cwd:'src/angular/', expand: true, src: ['fonts/*'], dest: 'dist/ui/'},
          {cwd:'src/angular/app/', expand: true, src: ['*.html'], dest: 'dist/ui/'},
          {cwd:'src/angular/app/', expand: true, src: ['**/*.html'], dest: 'dist/ui/'},
          {cwd:'src/', expand: true, src: ['vendor/**/**/**'], dest: 'dist/ui/js/'}
        ]
      }

    },
    
    coffee: {
      ui: {
          files: {
              'dist/ui/javascript/lunchfoo.js': ['src/angular/lib/*.coffee', 'src/angular/app/**/*.coffee', 'src/angular/app/app.coffee'] // compile and concat into single file
          }
      },
      api: {
            expand: true,
            cwd: 'src/express/',
            src: ['*.coffee', '**/*.coffee'],
            dest: 'dist/api',
            ext: '.js'
        }
    },
    sass: {                             
        dist: {                           
          options: {                      
            style: 'expanded'
          },
          files: {                         
            'dist/ui/css/main.css': 'src/angular/sass/main.scss'
          }
        }
    },   
    exec: {
        mongod : {
            command : 'mongod'
        },
        venue: {
            cwd: 'src/tasks',
            command: 'coffee venue_task.coffee'
        },
        fb: {
            cwd: 'src/tasks',
            command: 'coffee fb_task.coffee'
        }
    },
     supervisor: {
         express: {
             script: "dist/server.js",
             options: {
                 watch: [ "dist/api","dist/api/**/" ],
                 pollInterval: 100,
                 extensions: [ "js,jade" ]
             }
         }
     }

     
 });
 
 grunt.registerTask('default', [
     'sass:dist',
     'coffee:ui',
     'coffee:api',
     'copy',
     'concurrent:server'

 ]);




 grunt.registerTask('no-server', [
     'sass:dist',
     'coffee:ui',
     'coffee:api',
     'copy',
     'watch'

 ]);


grunt.registerTask('venue', [
    'exec:venue'
]);




 };