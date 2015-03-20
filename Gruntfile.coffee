# global module:false 
module.exports = (grunt) ->
  port = grunt.option("port") or 8000
  
  # Project configuration
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    meta:
      banner: "/*!\n" + " * reveal.js <%= pkg.version %> (<%= grunt.template.today(\"yyyy-mm-dd, HH:MM\") %>)\n" + " * http://lab.hakim.se/reveal-js\n" + " * MIT licensed\n" + " *\n" + " * Copyright (C) 2015 Hakim El Hattab, http://hakim.se\n" + " */"

    qunit:
      files: ["test/*.html"]

    uglify:
      options:
        banner: "<%= meta.banner %>\n"

      build:
        src: "js/reveal.js"
        dest: "js/reveal.min.js"

    sass:
      core:
        files:
          "css/reveal.css": "css/reveal.scss"

      themes:
        files:
          "css/theme/black.css": "css/theme/source/black.scss"
          "css/theme/white.css": "css/theme/source/white.scss"
          "css/theme/league.css": "css/theme/source/league.scss"
          "css/theme/beige.css": "css/theme/source/beige.scss"
          "css/theme/night.css": "css/theme/source/night.scss"
          "css/theme/serif.css": "css/theme/source/serif.scss"
          "css/theme/simple.css": "css/theme/source/simple.scss"
          "css/theme/sky.css": "css/theme/source/sky.scss"
          "css/theme/moon.css": "css/theme/source/moon.scss"
          "css/theme/solarized.css": "css/theme/source/solarized.scss"
          "css/theme/blood.css": "css/theme/source/blood.scss"
          "css/theme/sparkbox.css": "css/theme/source/sparkbox.scss"

    autoprefixer:
      dist:
        src: "css/reveal.css"

    cssmin:
      compress:
        files:
          "css/reveal.min.css": ["css/reveal.css"]

    jshint:
      options:
        curly: false
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noarg: true
        sub: true
        undef: true
        eqnull: true
        browser: true
        expr: true
        globals:
          head: false
          module: false
          console: false
          unescape: false
          define: false
          exports: false

      files: [
        "Gruntfile.js"
        "js/reveal.js"
      ]

    concat:
      files:
        cwd: 'markdown'
      options:
        separator: grunt.util.linefeed + grunt.util.linefeed
      short:
        src: [
          "markdown/build-right.md"
          "markdown/wifi.md"
          "markdown/list.md"
          "markdown/heading.md"
        ]
        dest: "outline.md"

      long:
        src: [
          "markdown/build-right.md"
          "markdown/wifi.md"
          "markdown/list.md"
          "markdown/heading.md"
        ]
        dest: "outline.md"

    connect:
      server:
        options:
          port: port
          base: "."
          livereload: true

    zip:
      "reveal-js-presentation.zip": [
        "index.html"
        "css/**"
        "js/**"
        "lib/**"
        "images/**"
        "plugin/**"
      ]

    watch:
      options:
        livereload: true

      js:
        files: [
          "Gruntfile.js"
          "js/reveal.js"
        ]
        tasks: "js"

      slides:
        files: ["markdown/*.md"]
        tasks: "concat"
        options:
          livereload: true

      theme:
        files: [
          "css/theme/source/*.scss"
          "css/theme/template/*.scss"
        ]
        tasks: "css-themes"

      css:
        files: ["css/reveal.scss"]
        tasks: "css-core"

      html:
        files: ["index.html"]

      markdown:
        files: [
          "Gruntfile.coffee"
        ]
        tasks: "concat"
        options:
          livereload: true

  
  # Dependencies
  grunt.loadNpmTasks "grunt-contrib-qunit"
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-sass"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-autoprefixer"
  grunt.loadNpmTasks "grunt-zip"
  
  # Default task
  grunt.registerTask "default", [
    "concat"
    "css"
    "js"
  ]
  
  # JS task
  grunt.registerTask "js", [
    "jshint"
    "uglify"
    "qunit"
  ]
  
  # Theme CSS
  grunt.registerTask "css-themes", ["sass:themes"]
  
  # Core framework CSS
  grunt.registerTask "css-core", [
    "sass:core"
    "autoprefixer"
    "cssmin"
  ]
  
  # All CSS
  grunt.registerTask "css", [
    "sass"
    "autoprefixer"
    "cssmin"
  ]
  
  # Package presentation to archive
  grunt.registerTask "package", [
    "default"
    "zip"
  ]

  grunt.registerTask "long", [
    "connect"
    "concat:long"
    "watch"
  ]

  grunt.registerTask "short", [
    "connect"
    "concat:short"
    "watch"
  ]

  # Serve presentation locally
  grunt.registerTask "serve", [
    "connect"
    "watch"
  ]
  
  # Run tests
  grunt.registerTask "test", [
    "jshint"
    "qunit"
  ]
  return
