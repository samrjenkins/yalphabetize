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

Yalphabetize is inspired by the brilliant [Rubocop](https://github.com/rubocop/rubocop) gem. Yalphabetize's CLI will be familiar to anybody already familiar with Rubocop.

Running yalphabetize on your project is a doddle!

```sh
$ cd my/unalphabetised/project
$ yalphabetize
```

Yalphabetize can even automatically alphabetize your YAML files for you. Just run:

```sh
$ cd my/unalphabetised/project
$ yalphabetize -a
```

To only run yalphabetize on a specific directory or file:

```sh
$ cd my/unalphabetised/project
$ yalphabetize path/to/directory path/to/file.yml
```

will run yalphabetize on all files within the `path/to/directory` directory as well as the `path/to/file.yml` file.

## Configuration

Yalphabetize can be configured through a `.yalphabetize.yml` file in your projects root directory.

### `only`

`only` is used to specify the yaml files which yalphabetize will inspect. When unspecified or empty, the default is to inspect all yaml files in the project.
When files are specified as command line arguments, `only` configuration is ignored.

Example:

```yml
# .yalphabetize.yml

only:
  - a_file.yml
  - a/directory/
  - a/glob/**/*.yml
```

### `exclude`

`exclude` is used to specify the yaml files which yalphabetize should not inspect within your project.

Example:

```yml
# .yalphabetize.yml

exclude:
  - a_file.yml
  - a/directory/
  - a/glob/**/*.yml
```

### `sort_by`

`sort_by` is used to specify the ordering which Yalphabetize uses when sorting a yaml file.

Examples of the four possible configuration values and their corresponding yaml ordering:

`sort_by: 'ABab'` (default)
```yml
Apples: 1
Bananas: 2
apples: 3
bananas: 4
```

`sort_by: 'abAB'`
```yml
apples: 1
bananas: 2
Apples: 3
Bananas: 4
```

`sort_by: AaBb`
```yml
Apples: 1
apples: 2
Bananas: 3
bananas: 4
```

`sort_by: aAbB`
```yml
apples: 1
Apples: 2
bananas: 3
Bananas: 4
```

### `indent_sequences`

`indent_sequences` is used to specify the indentation style of block sequences within mappings when the autocorrector is generating new YAML.

Examples:

`indent_sequences: true` (default)
```yml
Fruit:
  - Apples
  - Bananas
```

`indent_sequences: false`
```yml
Fruit:
- Apples
- Bananas
```

### `allowed_orders`

`allowed_orders` is used to specify custom sorting orders for matching sets (or subsets) of keys which you want to sort in an order that is not alphabetical.

Example:

```yml
allowed_orders:
  - [one two three four five]
  - [january february march april may]
```
```yml
months:
# The keys in this mapping match an allowed order exactly.
# They are ordered according to the matching allowed order.
  january: 1
  february: 2
  march: 3
  april: 4
  may: 5
numbers:
# The keys in this mapping match a subset of an allowed order.
# They are ordered according to the matching allowed order.
  one: 1
  two: 2
  three: 3
numbers_extended: 
# The keys in this mapping do not match an allow order or a subset of an allowed order (notice the extra `zero` key which does not appear in the allowed order of numbers).
# They are ordered alphabetically.
  one: 1
  three: 3
  two: 2
  zero: 0
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

## Compatibility

We aim for yalphabetize to be compatible with all actively maintained Ruby versions.

We currently support:
- MRI 3.0+

## Known issues
- Yalphabetize cannot currently preserve comments while automatically alphabetising a YAML file. Comments will have to be replaced after the alphabetisation.

## Contribute

We appreciate all contributions for this gem. You are very welcome to submit pull requests and issues and we will do our best to address them ASAP. Happy coding!
