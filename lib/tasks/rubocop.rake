# frozen_string_literal: true

namespace :rubocop do
  desc 'Run complete RuboCop code analyzer'
  task full: :environment do
    require 'rubocop'

    cli = RuboCop::CLI.new
    puts 'Running RuboCop...' if verbose
    options = [
      '--require', 'rubocop-rails',
      '--format', 'files',
      'lib', 'app', 'test'
    ]
    cli.run(options)
    puts 'RuboCop finished.'
  end

  desc 'Run RuboCop linter only'
  task linter: :environment do
    require 'rubocop'

    cli = RuboCop::CLI.new
    puts 'Running RuboCop linter...' if verbose
    options = [
      '--require', 'rubocop-rails',
      '--format', 'files',
      '--lint',
      'lib', 'app', 'test'
    ]
    result = cli.run(options)
    abort('RuboCop linter failed!') if result.nonzero?
    puts 'RuboCop linter finished.'
  end
end

desc 'Run RuboCop'
task rubocop: ['rubocop:full']
