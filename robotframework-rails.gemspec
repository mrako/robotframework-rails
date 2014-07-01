# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "robotframework_rails/version"

Gem::Specification.new do |s|
  s.name        = "robotframework-rails"
  s.version     = RobotframeworkRails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = ""
  s.authors     = ["Marko Klemetti"]
  s.email       = "marko.klemetti@gmail.com"
  s.homepage    = "http://github.com/mrako/robotframework-rails"
  s.summary     = "robotframework-rails-#{RobotframeworkRails::VERSION}"
  s.description = "Robot Framework Runner for Rails"

  s.files            = `git ls-files -- lib/*`.split("\n")
  s.files           += %w[README.md]
  s.test_files       = []
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"

  s.add_dependency 'rails', '>= 3'
end
