# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rubinius-melbourne/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian Shirai"]
  gem.email         = ["brixen@gmail.com"]
  gem.description   = %q{Ruby parser extracted from MRI.}
  gem.summary       = %q{Rubinius Ruby Parser.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rubinius-melbourne"
  gem.require_paths = ["lib"]
  gem.version       = Rubinius::Melbourne::VERSION
end
