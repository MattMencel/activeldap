#!/usr/bin/env ruby

$VERBOSE = true

$KCODE = 'u' if RUBY_VERSION < "1.9"

require 'yaml'

require 'bundler/setup'

base_dir = File.expand_path(File.dirname(__FILE__))
top_dir = File.expand_path(File.join(base_dir, ".."))
$LOAD_PATH.unshift(File.join(top_dir))
$LOAD_PATH.unshift(File.join(top_dir, "lib"))
$LOAD_PATH.unshift(File.join(top_dir, "test"))


require "test/unit"
Test::Unit::Priority.enable

test_file = "test/test_*.rb"
if ARGV[0]
  test_file = File.join('test', ARGV[0])
end
Dir.glob(test_file) do |file|
  require file
end

target_adapters = [nil]
# target_adapters << "ldap"
# target_adapters << "net-ldap"
# target_adapters << "jndi"
target_adapters.each do |adapter|
  ENV["ACTIVE_LDAP_TEST_ADAPTER"] = adapter
  puts "using adapter: #{adapter ? adapter : 'default'}"
  args = [File.dirname($0), ARGV.dup]
  if Test::Unit::AutoRunner.respond_to?(:standalone?)
    args.unshift(false)
  else
    args.unshift($0)
  end
  Test::Unit::AutoRunner.run(*args)
  puts
end
