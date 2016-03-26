PROJECT_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

$LOAD_PATH << "#{PROJECT_ROOT}/lib"
$LOAD_PATH << "#{PROJECT_ROOT}/spec"

require 'factory_girl'
require 'mocha/api'

RSpec.configure do |config|
  config.mock_with :mocha
  config.include FactoryGirl::Syntax::Methods
  config.include Mocha::API
end

