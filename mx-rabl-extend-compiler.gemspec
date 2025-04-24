# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mx/rabl/extend/compiler/version'

Gem::Specification.new do |spec|
  spec.name          = 'mx-rabl-extend-compiler'
  spec.version       = ::Mx::Rabl::Extend::Compiler::VERSION
  spec.authors       = ['Brandon Dewitt', 'MXDevExperience', 'Bryant Morrill']
  spec.email         = ['devexperience@mx.com', 'bryantreadmorrill@gmail.com']

  spec.summary       = ' a set of rake tasks to compile rabl templates for performance '
  spec.description   = ' a set of rake tasks to compile and verify rabl templates that use `extend` for moooooaaar performance '
  spec.homepage      = 'https://github.com/mxenabled/mx-rabl-extend-compiler'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rabl'
  spec.add_dependency 'rake', '>= 10'

  spec.add_development_dependency 'bundler', '~> 2.6'
  spec.add_development_dependency 'mad_rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
end
