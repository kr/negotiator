$:.unshift File.expand_path("../lib", __FILE__)
require "negotiator"

Gem::Specification.new do |gem|
  gem.name    = "negotiator"
  gem.version = Negotiator::VERSION

  gem.author      = "Keith Rarick"
  gem.email       = "kr@xph.us"
  gem.homepage    = "https://github.com/kr/negotiator"
  gem.summary     = "Correct HTTP Content Negotiation"
  gem.description = "Given an HTTP Accept header and a set of available content types, this gem will tell you what to do."

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(Readme.md|LICENSE|lib/|test/)} }
end
