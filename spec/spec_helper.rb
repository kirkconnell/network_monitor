spec_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.expand_path(File.join(spec_dir, "../lib"))

$:.unshift(lib_dir)
$:.uniq!

require 'rubygems'
require 'spec/autorun'
require 'network_monitor'