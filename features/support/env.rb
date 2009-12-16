require 'rubygems'
require 'tempfile'
require 'spec/expectations'
require 'fileutils'
require 'forwardable'

SCRATCH_SPACE = 'tmp'

class PairwiseWorld
  extend Forwardable
  def_delegators PairwiseWorld, :self_test_dir

  def self.examples_dir(subdir=nil)
    @examples_dir ||= File.expand_path(File.join(File.dirname(__FILE__), "../../#{SCRATCH_SPACE}"))
    subdir ? File.join(@examples_dir, subdir) : @examples_dir
  end

  def self.self_test_dir
    @self_test_dir ||= examples_dir
  end

  def pairwise_lib_dir
    @pairwise_lib_dir ||= File.expand_path(File.join(File.dirname(__FILE__), '../../lib'))
  end

  def initialize
    @current_dir = self_test_dir
  end

  private
  attr_reader :last_exit_status, :last_stderr

  def last_stdout
    @last_stdout
  end
  
  def create_file(file_name, file_content)
    in_current_dir do
      FileUtils.mkdir_p(File.dirname(file_name)) unless File.directory?(File.dirname(file_name))
      File.open(file_name, 'w') { |f| f << file_content }
    end
  end

  def set_env_var(variable, value)
    @original_env_vars ||= {}
    @original_env_vars[variable] = ENV[variable] 
    ENV[variable]  = value
  end

  def in_current_dir(&block)
    Dir.chdir(@current_dir, &block)
  end

  def run(command)
    stderr_file = Tempfile.new('pairwise')
    stderr_file.close
    in_current_dir do
      IO.popen("../bin/#{command} 2> #{stderr_file.path}", 'r') do |io|
        @last_stdout = io.read
      end

      @last_exit_status = $?.exitstatus
    end
    @last_stderr = IO.read(stderr_file.path)
  end
end

World do
  PairwiseWorld.new
end

Before do
  FileUtils.rm_rf SCRATCH_SPACE
  FileUtils.mkdir SCRATCH_SPACE
end
