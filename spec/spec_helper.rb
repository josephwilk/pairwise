require 'rubygems'
require 'rspec'

require 'simplecov'
SimpleCov.start
SimpleCov.command_name 'unit_tests'

require File.dirname(__FILE__) + '/../lib/pairwise'
