fs = require "fs"
path = require "path"
glob = require "glob"

assert = require "assert"
Testify = require "testify"
Testify.options.stack = false

test_path = path.resolve(__dirname, "..", "JSON-Schema-Test-Suite/tests")
module.exports = class SuiteRunner

  constructor: ({@version, @ignores}) ->
    @suites = {}
    @read()

  read: ->
    files = glob.sync "#{test_path}/#{@version}/**/*.json"
    prefix_length = "#{test_path}/#{@version}/".length


    for file in files
      # Get the attribute name by dropping the prefix and the .json
      key = file.slice(prefix_length, -5)

      continue if @ignores?[key] == true
      string = fs.readFileSync(file, "utf8")
      @suites[key] = require file

  test: ({validate, attribute, test_number}) ->

    Testify.test "JSON Schema: #{@version}", (context) =>
      if attribute
        attribute_suite = @suites[attribute]
        if !attribute_suite
          throw new Error "No such attribute to test: '#{attribute}'"
        else
          @run_attribute({validate, context, attribute, attribute_suite, test_number})
        if @ignores?[attribute]
          process.on "exit", =>
            console.log "Ignored these tests for #{@version}:", @ignores[attribute]
      else
        @run_all({validate, context, @suites})
        if @ignores
          process.on "exit", =>
            console.log "Ignored these tests for #{@version}:"
            for attribute, val of @ignores
              if val == true
                console.log "\t", attribute
              else
                console.log "\t", "#{attribute}:", val

  run_all: ({validate, context, suites}) ->
    for attribute, attribute_suite of suites
      context.test attribute, (context) =>
        for suite, i in attribute_suite
          unless @ignores?[attribute]?.some((item) => item == suite.description)
            context.test suite.description, () =>

              for document in suite.tests
                unless @ignores?[attribute]?.some((item) => item == document.description)
                  result = validate(suite.schema, document.data)
                  assert.equal result.valid, document.valid,
                    "Failed '#{document.description}'"


  run_attribute: ({validate, context, attribute, attribute_suite, test_number}) ->
    context.test attribute, (context) =>
      if test_number
        if suite = attribute_suite[parseInt(test_number)]
          @run_subsuite({validate, context, suite})
        else
          console.log "Usage error: #{attribute} only has #{attribute_suite.length} tests"
          process.exit()
      else
        for suite, i in attribute_suite
          unless @ignores?[attribute]?.some((item) => item == suite.description)
            @run_subsuite({attribute, validate, context, suite})

  run_subsuite: ({attribute, validate, context, suite}) ->
    context.test suite.description, (context) =>

      for document in suite.tests
        unless @ignores?[attribute]?.some((item) => item == document.description)
          context.test document.description, =>
            result = validate(suite.schema, document.data)
            if result.valid
              x = "valid"
            else
              x = "invalid"
            assert.equal result.valid, document.valid,
              "Result was #{x}"




