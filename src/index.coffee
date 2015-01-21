path = require "path"

SuiteRunner = require "./suite_runner"

module.exports = (validator_path, attribute, test_number) ->

  {version, validator, ignores} = require path.resolve(validator_path)

  unless version?
    throw new Error "Validator adapter must specify version"


  runner = new SuiteRunner {version, ignores}

  runner.test {validator, attribute, test_number}
  #runner.test {validator}


