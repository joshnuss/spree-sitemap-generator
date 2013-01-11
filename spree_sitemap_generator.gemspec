Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_sitemap_generator'
  s.version     = '1.1.1'
  s.summary     = 'Provides a sitemap file for Spree'
  s.required_ruby_version = '>= 1.8.7'

  s.authors            = ['Joshua Nussbaum', 'Michael Bianco']
  s.email              = ['joshnuss@gmail.com', 'info@cliffsidedev.com']
  s.homepage          = 'https://github.com/iloveitaly/spree-sitemap-generator'

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.1'
  s.add_dependency 'sitemap_generator', '~> 3.4'
end
