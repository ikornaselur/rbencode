
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbencode/version'

Gem::Specification.new do |spec|
  spec.name          = 'rbencode'
  spec.version       = Rbencode::VERSION
  spec.authors       = ['Axel Örn Sigurðsson']
  spec.email         = ['axel@takumi.com']

  spec.summary       = 'A serializer for the Bit Torrent bencoding format'
  spec.homepage      = 'https://github.com/ikornaselur/rbencode'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'bond', '~> 0.5.1'
end
