# -*- encoding: utf-8 -*-
require 'rubinius/toolset'
require './lib/rubinius/melbourne/version'

Gem::Specification.new do |spec|
  spec.authors       = ["Brian Shirai"]
  spec.email         = ["brixen@gmail.com"]
  spec.description   = %q{Ruby parser extracted from MRI.}
  spec.summary       = %q{Rubinius Ruby Parser.}
  spec.homepage      = "https://github.com/rubinius/rubinius-melbourne"
  spec.license       = "BSD"

  spec.files         = `git ls-files`.split($\)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.extensions    = ["ext/rubinius/melbourne/extconf.rb"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.name          = "rubinius-melbourne"
  spec.require_paths = ["lib"]
  spec.version       = Rubinius::ToolSet.current::TS::Melbourne::VERSION

  spec.add_runtime_dependency     "rubinius-toolset"

  spec.add_development_dependency "rubinius-toolset", "~> 2.0"
  spec.add_development_dependency "redcard", "~> 1.0"
  spec.add_development_dependency "mspec", "~> 1.5"
  spec.add_development_dependency "rake",  "~> 10.0"
end
