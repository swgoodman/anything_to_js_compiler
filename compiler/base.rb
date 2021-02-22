require_relative 'structs'
require_relative 'tokenizer'
require_relative 'parser'
require_relative 'generator'

# Executes compilation steps
class Compiler
  def initialize(code)
    @code = code
  end

  def run
    tokens = Tokenizer.new(File.read(@code)).tokenize
    tree = Parser.new(tokens).parse
    Generator.new.generate(tree)
  end
end
