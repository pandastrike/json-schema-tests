path = require "path"

SuiteRunner = require "./suite_runner"

module.exports = (validator_path, attribute, test_number) ->

  {version, validate, ignores} = require path.resolve(validator_path)

  unless version? && validate?
    throw new Error "You must specify a version and a validate function"

  runner = new SuiteRunner {version, ignores}

  runner.test {validate, attribute, test_number}


