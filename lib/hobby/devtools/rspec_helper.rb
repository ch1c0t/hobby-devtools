require 'hobby/test'
require 'puma'

require 'rspec/power_assert'
RSpec::PowerAssert.example_assertion_alias :assert
RSpec::PowerAssert.example_group_assertion_alias :assert

require 'hobby/devtools/mutant'
require 'hobby/devtools/rspec'

RSpec.configure do |config|
  unless ENV['PRY']
    require 'timeout'
    config.around :each do |example|
      Timeout.timeout 2, &example
    end
  end
end
