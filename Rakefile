desc "Run RuboCop"
task :lint do
  sh "bundle exec rubocop"
end

desc "Run RuboCop"
task :test do
  sh "bundle exec rspec"
end

task default: %i[lint test]
