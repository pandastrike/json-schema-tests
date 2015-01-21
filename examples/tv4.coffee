tv4 = require("tv4").tv4

module.exports =

  version: "draft4"

  validator: (schema) ->
    (document) ->
      result = tv4.validateResult(document, schema)
      {valid: result.valid}



  ignores:
    "optional/format": true

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


