path = require "path"

SuiteRunner = require "./suite_runner"

module.exports = (validator_path, attribute, test_number) ->

  {version, validator, ignores} = require path.resolve(validator_path)

  unless version? && validator?
    throw new Error "You must specify a version and a validator function"

  runner = new SuiteRunner {version, ignores}

  runner.test {validator, attribute, test_number}


