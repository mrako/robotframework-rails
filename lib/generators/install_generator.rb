require 'rails'

module Robotframework
  class InstallGenerator < Rails::Generators::Base
    def self.source_root
      @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end
    def copy_config_file
      template 'config/robot.yml'
    end
  end
end

