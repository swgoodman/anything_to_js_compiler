# !/usr/bin/env ruby
require_relative '../compiler/base'

generated = Compiler.new('test.src').run

# Hardcode runtime JS function to validate executable
RUNTIME = 'function add(x, y) { return x + y };'.freeze
TEST = 'console.log(f(1,2))'.freeze
puts [RUNTIME, generated, TEST].join("\n")

