# !/usr/bin/env ruby
# frozen_string_literal: true,

# Identify components (tokens) of given code
class Tokenizer
  # Stored as an array of arrays because order and precedence is important
  TOKEN_TYPES = [
    [:def, /\bdef\b/],
    [:end, /\bend\b/],
    [:identifier, /\b[a-zA-Z]+\b/],
    [:integer, /\b[0-9]+\b/],
    [:oparen, /\(/],
    [:cparen, /\)/]
  ].freeze

  def initialize(code)
    @code = code
  end

  def tokenize
    tokens = []
    until @code.empty?
      tokens << tokenize_one_token
      @code = @code.strip
    end
    tokens
  end

  def tokenize_one_token
    TOKEN_TYPES.each do |type, re|
      re = /\A(#{re})/
      if @code =~ re
        value = $1
        @code = @code[value.length..-1]
        return Token.new(type, value)
      end
    end
    raise RuntimeError.new(
      "Couldn't match token on #{@code.inspect}"
    )
  end
end

Token = Struct.new(:type, :value)

# Transform token stream into a tree structure representing token relations
class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  def parse
    parse_def
  end

  def parse_def
    consume(:def)
    name = consume(:identifier).value
    arg_names = parse_arg_names
    body = parse_expr
    consume(:end)
    DefNode.new(name, arg_names, body)
  end

  def parse_arg_names
    consume(:oparen)
    consume(:cparen)
    []
  end

  def parse_expr
    parse_integer
  end

  def parse_integer
    IntegerNode.new(consume(:integer).value.to_i)
  end

  def consume(expected_type)
    token = @tokens.shift
    if token.type == expected_type
      token
    else
      raise RuntimeError.new(
        "Expected token type #{expected_type.inspect} but got #{token.type.inspect}"
      )
    end
  end
end

DefNode = Struct.new(:name, :arg_names, :body)
IntegerNode = Struct.new(:value)

tokens = Tokenizer.new(File.read('test.src')).tokenize

puts tokens.map(&:inspect).join("\n")

tree = Parser.new(tokens).parse

p tree