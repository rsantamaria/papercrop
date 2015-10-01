$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shared_rails"
  s.version     = "0.0.0"
  s.authors     = ["name"]
  s.email       = ["email"]
  s.homepage    = "none"
  s.summary     = "Shared content between rails test apps"
  s.description = "Shared content between rails test apps"

  s.files      = Dir["{app,config,db,lib}/**/*"]
  s.test_files = Dir["test/**/*"]
end
