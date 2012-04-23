# Seed-O-Matic
*Run repeatable seeds across a variety of environments*

Seeds are great, but they're usually written in a way that they can only be used on an initial deploy. Seed-O-Matic gives
you tools to specify seed data in a way that's repeatable across environments, allowing you to change seed data in a safe
way between all of your environments.

## Seed Files
Seed files are set up as YAML files. By default, Seed-O-Matic will look for seed files in `config/seeds`, although you can
specify another directory when you run your seeds. Here's the structure of a typical seed file:

    my_model:
      match_on: code
      tags: [initial_run, professional]
      items:
        - name: My Model 1
          code: my_model
        - name: My Model 2
          code: my_model_2

* The seed file starts with a *model name*. This should match the name of a model in your application.
* The *items* array lists all the items you'd like to seed. Attribute names should match the name of your attributes.
* You can specify a *match_on* attribute to prevent duplicate entries being created when seeds are run a second time.
  Seed-O-Matic will try to find an entry which matches your match_on fields, and update if one is found. Multiple items work as well.
* You can tag your seed files as well, if you want to import a subset of seeds in particular circumstances.

## Running Seeds

Running seeds is as easy as calling:

    SeedOMatic.run

This will look through the directory `config/seeds`, and import every file in that directory.

### Importing specific directories, or specific files.

To load seed files from a specific directory, call:

    SeedOMatic.run :dir => "your/directory"

To load a specific seed file, call:

    SeedOMatic.run :file => 'config/seeds/my_model.yml'

### Importing tags

You can load tags using the `tagged_with`, and `not_tagged_with` options:

    SeedOMatic.run :tagged_with => 'my_tag'              # Will run all seeds tagged with my_tag
    SeedOMatic.run :tagged_with => ['tag1', 'tag2']      # Will run if tagged with either tag1 or tag2
    SeedOMatic.run :not_tagged_with => ['tag1', 'tag2']  # Will not run if either tag1 or tag2

## TODO

* Support for JSON formatted seed files
* Allowing multiple models defined per file
* Referencing lookups from other seed files
* Selective updating of data