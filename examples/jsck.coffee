JSCK = require("jsck/lib/index")

module.exports =

  version: "draft4"

  validate: (schema, document) ->
    v = new JSCK.draft4(schema)
    v.validate(document)


  ignores:
    # Doubtful value for the majority of use cases.
    # https://github.com/pandastrike/jsck/issues/42
    minLength: [
      "one supplementary Unicode code point is not long enough"
    ]
    maxLength: [
      "two supplementary Unicode code points is long enough"
    ]

    # Not supported because of the potential performance implications
    # https://github.com/pandastrike/jsck/issues/2
    uniqueItems: true

    # Impossible to test when using output of JSON.parse
    # https://github.com/pandastrike/jsck/issues/6
    "optional/zeroTerminatedFloats": true
    
    # The following items require fetching of remote schemas.
    # Support for remote references is planned for the next version of JSCK
    refRemote: true
    ref: [
      "remote ref, containing refs itself"
    ]
    definitions: true
