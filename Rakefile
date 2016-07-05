require "bundler/gem_tasks"

task :default => :test

desc 'Run Rails integration test'
task :test do
  exit(1) unless ruby('rails_integration_test.rb')
end
