
Gem::Specification.new do |s|
  s.name          = 'papercrop'
  s.version       = '0.0.2'
  s.date          = '2012-08-12'
  s.summary       = "Paperclip extension for cropping images"
  s.description   = "Paperclip extension for cropping images"
  s.authors       = ["Ruben Santamaria"]
  s.email         = 'rsantamaria.dev@gmail.com'
  s.homepage      = 'https://github.com/rsantamaria/papercrop'

  s.files         = Dir.glob("{lib,vendor}/**/*") + %w(README.md)
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "paperclip", "~> 3.1"
end