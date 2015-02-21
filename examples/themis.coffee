themis = require("themis")

module.exports =

  version: "draft4"

  validate: (schema, document) ->
    v = themis.validator(schema)
    {valid: v(document, '0').valid}

  ignores:

    # Impossible to test when using output of JSON.parse
    # https://github.com/pandastrike/jsck/issues/6
    "optional/zeroTerminatedFloats": true

    # These require fetching remote schemas
    refRemote: true
    ref: [ "remote ref, containing refs itself" ]
    definitions: true

