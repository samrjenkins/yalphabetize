# yalphabetize
Alphabetize your YAML files!

Yalphabetize is a static code analyser and code formatter for alphabetising key-value pairs in your project's YAML files. Yalphabetize not only alerts you to alphabetisation offences in your YAML files but can also automatically fix them for you.

**Please note:** yalphabetize is still a young project. Please ensure you review any changes yalphabetize has made to your YAML files before commiting them to your project.

## Installation

Installing yalphabetize is easy:

```sh
$ gem install yalphabetize
```

To install with bundler add the following to your Gemfile (set the `require` option to `false`, as it is a standalone tool):

```ruby
gem 'yalphabetize', require: false
```

## Quickstart

Running yalphabetize on your project is easy too:

```sh
$ cd my/unalphabetised/project
$ yalphabetize
```

Yalphabetize can even automatically alphabetize your YAML files for you. Just run:

```sh
$ cd my/unalphabetised/project
$ yalphabetize -a
```

## Adding yalphabetize to your project's CI

Yalphabetize is a great addition to any linting you might currently perform as part of CI. The `yalphabetize` executable exits with exit code `0` when no offences are detected, or exits with `1` if offences are detected.

Example travis script:

```yml
# .travis.yml

script:
  - bundle exec yalphabetize
  - bundle exec rubocop
  - bundle exec rails_best_practices
  - bundle exec rspec

```

## Known issues
- Yalphabetize cannot currently preserve comments while automatically alphabetising a YAML file. Comments will have to be replaced after the alphabetisation.

## Contribute

We appreciate all contributions for this gem. You are very welcome to submit pull requests and issues and we will do our best to address them ASAP. Happy coding!
