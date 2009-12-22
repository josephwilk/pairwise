require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "pairwise"
    gem.summary = %Q{Turn large test data combinations into smaller ones}
    gem.description = %Q{A tool for selecting a smaller number of test combinations (using pairwise generation) rather than exhaustively testing all possible permutations.}
    gem.email = "joe@josephwilk.net"
    gem.homepage = "http://wiki.github.com/josephwilk/pairwise"
    gem.authors = ["Joseph Wilk"]

    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'cucumber'
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Dir['gem_tasks/**/*.rake'].each { |rake| load rake }

task :default => ["spec", "features"]
