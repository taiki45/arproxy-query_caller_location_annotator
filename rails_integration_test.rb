require 'fileutils'
require 'open3'

def execute_without_bundler
  defined?(Bundler) ? Bundler.with_clean_env { yield } : yield
end

name = 'test_app'

execute_without_bundler do
  system('bundle install -j8')
  FileUtils.rm_rf('tmp')
  FileUtils.mkdir_p('tmp')
  Dir.chdir('tmp') do
    system("bundle exec rails new #{name} --skip-bundle")
    Dir.chdir(name) do
      lines = File.read('Gemfile').split("\n")
      lines.reject! {|l| l.match(/sqlite3/) }
      new = lines.first(1) + [
        %!gem "mysql2"!,
        %!gem "arproxy-query_caller_location_annotator", path: "#{__dir__}"!,
      ] + lines.drop(1)
      File.open('Gemfile', 'w') {|f| f.puts(new.join("\n")) }

      database_config = File.read('config/database.yml')
      database_config.gsub!('adapter: sqlite3', 'adapter: mysql2')
      database_config.gsub!(%r{database: db/\w+.sqlite3}, 'database: arproxy_test_app')
      File.write('config/database.yml', database_config)

      system('bundle install -j8')
      system('bin/rails db:drop db:setup')
      system('bin/rails g model user name:string')
      system('bin/rails db:migrate')

      File.write('app/models/user.rb', <<-EOF)
class User < ApplicationRecord
  def self.xxx
    first
  end
end
      EOF

      config = File.read('config/environments/development.rb')
      config << "\nRails.application.config.logger = Logger.new(STDOUT)\n"
      File.write('config/environments/development.rb', config)

      log, e, s = Open3.capture3(%!bin/rails runner 'User.create(name: "alice"); p User.xxx'!)
      puts log, e

      raise("Failed to run script:\n#{e}") unless s.success?
    end
  end
end
