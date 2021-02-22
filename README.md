# "Anything to JS" Compiler 📬

An investigation into the underlying components of compilation. This implementation would likely be considered ["source to source"](https://en.wikipedia.org/wiki/Source-to-source_compiler) compilation, as it is best prepared to translate two high level languages. This was built in Ruby with comprehension and readability in mind, not performance.

Generally, the steps of a compiler can be broken down into:

* **Lexical Analysis (Tokenization)**: _"Identify components (tokens) of given code"_
* **Parsing**: _"Transform token stream into a tree structure representing token relations"_
* **Generation**: _"Generate the desired code"_

Real compilers will feature additional subtasks and speed optimizations, such as ["preprocessing"](https://en.wikipedia.org/wiki/Preprocessor) and ["dead code elimination"](https://en.wikipedia.org/wiki/Dead_code_elimination).
