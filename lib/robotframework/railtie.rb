require 'robotframework-rails'

module RobotframeworkRails
  require 'rails'

  class Railtie < Rails::Railtie
    rake_tasks { load "tasks/robotframework.rake" }

    generators { load "generators/install_generator.rb" }
  end
end
