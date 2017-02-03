var gulp = require('gulp')
var path = require('path')
var standard = require('gulp-standard')
var sassLint = require('gulp-sass-lint')

var config = require('../config')

gulp.task('standardjs', function () {
  return gulp.src([path.join(config.assetsPath, '**/*.js'), 'gulp/**/*.js'])
    .pipe(standard())
    .pipe(standard.reporter('default', {
      breakOnError: false,
      quiet: true,
      showRuleNames: true
    }))
})

gulp.task('sass-lint', function () {
  var sassFiles = [
    path.join(config.assetsPath, 'src/scss/**/*.s+(a|c)ss'),
    '!' + path.join(config.assetsPath, 'src/scss/vendor/**')
  ]

  return gulp.src(sassFiles)
    .pipe(sassLint({
      rules: {
        'property-sort-order': 0,
        'force-element-nesting': 0,
        'no-color-literals': 0,
        'force-pseudo-nesting': 0,
        'shorthand-values': 0,
        'mixins-before-declarations': 0
      }
    }))
    .pipe(sassLint.format())
    .pipe(sassLint.failOnError())
})

gulp.task('test', ['standardjs', 'sass-lint'])
