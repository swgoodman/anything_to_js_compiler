CallNode = Struct.new(:name, :arg_exprs)
DefNode = Struct.new(:name, :arg_names, :body)
IntegerNode = Struct.new(:value)
Token = Struct.new(:type, :value)
VarRefNode = Struct.new(:value)