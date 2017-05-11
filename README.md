# ApiClient: a mix gen template for building elixir clients to 3rd party (RESTful) APIs.

A template

You use this repo to bootstrap your elixir client for your HTTP API
you are attempting to access (e.g. Digital Ocean, Google Calendar, Strike, DropBox).

This is an alternative for `mix new`, based on [Dave Thomas'](https://github.com/pragdave/mix_templates) extensible templating engine for creating project templates.

You use it in combination with the `mix gen` mix task, which you will need
to install.

## New Project Template

        mix gen api_client «name» [ --into «path» ] [--app[lication] «app»] [--module «module»]

## Install

This template is installed using the `template.install` mix task.
Projects are generated from it using the `mix gen` task.

So, before using templates for the first time, you need to install these two tasks:

    $ mix archive.install mix_templates
    $ mix archive.install mix_generator

Then you can install this template using

    $ mix template.install gen_template_api_client


## Use

To create a new project run:

```
$ mix gen api_client «project_name»
```

`«project_name»` is both the name of the subdirectory that will hold the
project and the name that will be given to the application. This
affects entries in `mix.exs` as well as the names of the main
file in `lib/` and the skeleton test in `test/`. The application
module name will be the camelcase version of «name».

By default the subdirectory will be created under your
current directory; you can change this with the `--into` option:

```
$ mix gen api_client «project_name» --into some/other/dir
```

### Variants

The application's `start` function is created in
`lib/«name»/application.ex`, along with a basic supervisor.

You can change the name used for the application:

```
$ mix gen api_client «project_name» --app[lication] «app»
```

The original «project_name» parameter will be the
name used for the directory, and «app» will be used when
creating file names in that directory and when customizing the
file contents.

Finally, you can override the name used for the application module:

```
$ mix gen api_client «project_name» --module «Module»
```

«Module» must be a valid Elixir module name or alias.

## More Info On `mix gen`

You can [watch a video of Dave Thomas](https://player.vimeo.com/video/213689412)
explaining the new generator project, and how to use it.

You can also look at his projects related to project generation.

* https://github.com/pragdave/mix_templates
* https://github.com/pragdave/gen_template_template
* https://github.com/pragdave/gen_template_project
