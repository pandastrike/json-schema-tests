fs = require "fs"
glob = require "glob"

assert = require "assert"
Testify = require "testify"

module.exports = class SuiteRunner

  constructor: ({@version, @ignores}) ->
    @suites = {}
    @read()

  read: ->
    files = glob.sync "JSON-Schema-Test-Suite/tests/#{@version}/**/*.json"
    l = "JSON-Schema-Test-Suite/tests/#{@version}/".length

    for file in files
      # drop the .json
      key = file.slice(l, -5)

      continue if @ignores?[key] == true
      string = fs.readFileSync(file, "utf8")
      @suites[key] = require "../#{file}"

  test: ({validator, attribute, test_number}) ->

    Testify.test "JSON Schema: #{@version}", (context) =>
      if attribute
        attribute_suite = @suites[attribute]
        if !attribute_suite
          throw new Error "No such attribute to test: '#{attribute}'"
        else
          @run_attribute({validator, context, attribute, attribute_suite, test_number})
        if @ignores?[attribute]
          process.on "exit", =>
            console.log "Ignored these tests for #{@version}:", @ignores[attribute]
      else
        for attribute, attribute_suite of @suites
          @run_attribute({validator, context, attribute, attribute_suite, test_number})
        if @ignores
          process.on "exit", =>
            console.log "Ignored these tests for #{@version}:"
            for attribute, val of @ignores
              if val == true
                console.log "\t", attribute
              else
                console.log "\t", "#{attribute}:", val

  run_attribute: ({validator, context, attribute, attribute_suite, test_number}) ->
    context.test attribute, (context) =>
      if test_number
        if suite = attribute_suite[parseInt(test_number)]
          @run_subsuite({validator, context, suite})
        else
          console.log "Usage error: #{attribute} only has #{attribute_suite.length} tests"
          process.exit()
      else
        for suite, i in attribute_suite
          unless @ignores?[attribute]?.some((item) => item == suite.description)
            @run_subsuite({attribute, validator, context, suite})

  run_subsuite: ({attribute, validator, context, suite}) ->
    context.test suite.description, (context) =>
      v = validator(suite.schema)

      for document in suite.tests
        unless @ignores?[attribute]?.some((item) => item == document.description)
          context.test document.description, =>
            result = v.validate(document.data)
            assert.equal result.valid, document.valid

