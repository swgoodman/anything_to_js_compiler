# !/usr/bin/env ruby
require_relative 'structs'
# Identify components (tokens) of given code
class Tokenizer
  # Stored as an array of arrays because order and precedence is important
  TOKEN_TYPES = [
    [:def, /\bdef\b/],
    [:end, /\bend\b/],
    [:identifier, /\b[a-zA-Z]+\b/],
    [:integer, /\b[0-9]+\b/],
    [:oparen, /\(/],
    [:cparen, /\)/],
    [:comma, /,/]
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
      next unless @code =~ re

      value = Regexp.last_match[0]
      @code = @code[value.length..-1]
      return Token.new(type, value)
    end
    raise "Couldn't match token on #{@code.inspect}"
  end
end

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
    arg_names = []

    consume(:oparen)
    if peek(:identifier)
      arg_names << consume(:identifier).value
      while peek(:comma)
        consume(:comma)
        arg_names << consume(:identifier).value
      end
    end
    consume(:cparen)
    arg_names
  end

  def parse_expr
    if peek(:integer)
      parse_integer
    elsif peek(:identifier) && peek(:oparen, 1)
      parse_call
    else
      parse_var_ref
    end
  end

  def parse_integer
    IntegerNode.new(consume(:integer).value.to_i)
  end

  def parse_call
    name = consume(:identifier).value
    arg_exprs = parse_arg_exprs
    CallNode.new(name, arg_exprs)
  end

  def parse_arg_exprs
    arg_exprs = []

    consume(:oparen)
    if !peek(:cparen)
      arg_exprs << parse_expr
      while peek(:comma)
        consume(:comma)
        arg_exprs << parse_expr
      end
    end
    consume(:cparen)
    arg_exprs
  end

  def parse_var_ref
    consume(:identifier)
  end

  def consume(expected_type)
    token = @tokens.shift
    unless token.type == expected_type
      raise "Expected token type #{expected_type.inspect} but got #{token.type.inspect}"
    end

    token
  end

  def peek(expected_type, offset = 0)
    @tokens.fetch(offset).type == expected_type
  end
end
