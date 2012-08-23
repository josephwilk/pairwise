require 'rubygems'
require 'bundler'
Bundler.require(:test)

SimpleCov.start
SimpleCov.command_name 'unit_tests'

require File.dirname(__FILE__) + '/../lib/pairwise'