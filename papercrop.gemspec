
Gem::Specification.new do |s|
  s.name          = 'papercrop'
  s.version       = '0.0.5'
  s.date          = '2012-08-12'
  s.summary       = "Paperclip extension for cropping images"
  s.description   = "An easy extension for Paperclip to crop your image uploads using jCrop"
  s.authors       = ["Ruben Santamaria"]
  s.email         = 'rsantamaria.dev@gmail.com'
  s.homepage      = 'https://github.com/rsantamaria/papercrop'

  s.files         = Dir.glob("{lib,vendor}/**/*") + %w(README.md)
  s.test_files    = Dir.glob("{spec}/**/*")
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 3.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "paperclip", ">= 3.1"

  s.add_development_dependency "rspec-rails", "~> 2.0"
  s.add_development_dependency "capybara", ">= 1.1.1"
  s.add_development_dependency "rmagick"
  s.add_development_dependency "sass"
  s.add_development_dependency "sqlite3"
end