require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rubygems/package_task'

RSpec::Core::RakeTask.new

task :default => [ :spec ]

spec = eval(File.read('spree_wirecard.gemspec'))

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc "Release to gemcutter"
task :release => :package do
  require 'rake/gemcutter'
  Rake::Gemcutter::Tasks.new(spec).define
  Rake::Task['gem:push'].invoke
end
