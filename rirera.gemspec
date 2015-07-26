$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rirera/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rirera"
  s.version     = Rirera::VERSION
  s.authors     = ["Maximilian Meister"]
  s.email       = "mmeister@suse.de"
  s.homepage    = "http://github.com/MaximilianMeister/rirera"
  s.summary     = "Risk Reward Ratio."
  s.description = "A simple Risk Reward Ratio calculator."
  s.license     = "MIT"


  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.12"
  s.add_dependency "haml-rails", "~> 0.9.0"
  s.add_dependency "colorize", ["~> 0.7", ">= 0.7.3"]
  s.add_dependency "trollop", ["2.0"]
  s.post_install_message = "Happy trading!"

  s.add_development_dependency "sqlite3"

end
