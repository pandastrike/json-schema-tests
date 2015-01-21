imjv = require("is-my-json-valid")

module.exports =

  version: "draft4"

  validator: (schema) ->
    x = imjv(schema)
    (document) ->
      {valid: x(document)}



  ignores:
    # Using the same ignores as JSCK for parity's sake

    # Doubtful value for the majority of use cases.
    minLength: [
      "one supplementary Unicode code point is not long enough"
    ]
    maxLength: [
      "two supplementary Unicode code points is long enough"
    ]

    # Not supported because of the potential performance implications
    uniqueItems: true

    # Impossible to test when using output of JSON.parse
    "optional/zeroTerminatedFloats": true
    
    # The following items require fetching of remote schemas.
    refRemote: true
    ref: [
      "remote ref, containing refs itself"
    ]
    definitions: true

