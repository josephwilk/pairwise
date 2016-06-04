require File.dirname(__FILE__) + '/lib/version'

Gem::Specification.new do |s|

    s.name = "pairwise_not_so_syck"
    s.summary = %Q{Turn large test data combinations into smaller ones}
    s.description = %Q{A tool for selecting a smaller number of test combinations (using pairwise generation) rather than exhaustively testing all possible permutations.
            To read about why, go here: http://wiki.github.com/josephwilk/pairwise
            This variation uses the newer psych json engine}
    s.email = "ali@animoto.com"
    s.homepage = "http://wiki.github.com/josephwilk/pairwise"
    s.authors = ["Joseph Wilk","Ali King"]
    s.require_paths = %w[lib]
    s.files = %w[README.md] + Dir.glob("{examples,lib,spec}/**/*.rb")
    s.version = Pairwise::VERSION
    s.executables  = ['pairwise']

    s.add_dependency 'unicode-display_width'
    s.add_development_dependency 'rspec'
    s.add_development_dependency 'cucumber'
end

