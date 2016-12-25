module Hobby
  module Devtools
    class RSpec
      def self.describe &block
        new &block
      end

      def initialize &block
        instance_exec &block
        @specs.each do |file|
          test = Hobby::Test.from_file file
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
              assert { @report.ok? }
            end
          end
        end
      end

      def app &block
        @app = block
      end

      def path string
        @specs = Dir[string]
      end
    end
  end
end
