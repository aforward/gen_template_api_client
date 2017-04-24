defmodule Mix.Gen.Template.ApiClient do

  @moduledoc File.read!(Path.join([__DIR__, "../README.md"]))

  use MixTemplates,
    name:       :api_client,
    short_desc: "Template for creating REST API client wrappers in Elixir",
    source_dir: "../template",
    options:    [
      app: [
        to:       :app,
        required: false,
        takes:    "app_name",
        desc:     "sets the application name to «app_name»"
      ],
      application: [ same_as: :app ],

      module: [
         to:        :project_name_camel_case,
         required:  false,
         takes:     "«project_name»",
         desc:      "sets the name of the module to «project_name»"
       ]
    ]
end
