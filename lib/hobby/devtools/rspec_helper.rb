require 'hobby/test'
require 'puma'

require 'hobby/devtools/power_assert'
require 'hobby/devtools/mutant'
require 'hobby/devtools/rspec'

RSpec.configure do |config|
  config.expect_with :rspec, :minitest

  unless ENV['PRY']
    require 'timeout'
    config.around :each do |example|
      Timeout.timeout 1, &example
    end
  end

  config.after :suite do
    `rm *.socket` unless Dir['*.socket'].empty?
  end
end
