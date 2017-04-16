module Hobby
  module Devtools
    ::RSpec::Matchers.define :be_ok do
      match &:ok?
      failure_message do |report|
        report.map.with_index do |exchange_report, index|
          <<~S
            Index: #{index}
            Status: #{exchange_report.ok? ? "passed" : "failed"}
            Request:
              #{exchange_report.request.template}
              #{exchange_report.request}
            Expected response:
              #{exchange_report.expected_response.template}
              #{exchange_report.expected_response}
            Actual response:
              #{exchange_report.actual_response}
          S
        end.join '-----------------------------'
      end
    end

    class RSpec
      def self.describe &block
        new &block
      end

      def initialize &block
        @path = 'spec/http'
        instance_exec &block

        Dir["#{@path}/**/*.yml"].each do |file|
          test = Hobby::Test.from_file file, format: @format
          ::RSpec.describe [test, @app] do
            before :each do |example|
              test, app = described_class

              socket = "app.for.#{test}.socket"
              @pid = fork do
                server = Puma::Server.new app.call
                server.add_unix_listener socket
                server.run
                sleep
              end

              sleep 0.01 until File.exist? socket

              @report = test[socket]
            end

            after(:each) { `kill -9 #{@pid}` }

            it 'works' do
              expect(@report).to be_ok
            end
          end
        end
      end

      def app &block
        @app = block
      end

      def path path
        @path = path
      end

      def format format
        @format = format
      end
    end
  end
end
