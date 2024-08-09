# frozen_string_literal: true

require_relative 'config/application'

Rails.application.load_tasks

require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc 'Run all tests'
task test: %i[spec rubocop]

task default: :test
