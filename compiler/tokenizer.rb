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