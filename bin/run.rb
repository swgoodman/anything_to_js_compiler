require_relative '../compiler'

tokens = Tokenizer.new(File.read('test.src')).tokenize

puts tokens.map(&:inspect).join("\n")

tree = Parser.new(tokens).parse

p tree