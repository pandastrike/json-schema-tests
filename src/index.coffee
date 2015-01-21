path = require "path"

SuiteRunner = require "./suite_runner"

module.exports = ({version, validate, attribute, test_number, ignores}) ->

  runner = new SuiteRunner {version, ignores}

  runner.test {validate, attribute, test_number}


