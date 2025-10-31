(
 [
  (import_statement 
    name: 
    (dotted_name 
      (identifier) @module )) 
  (import_from_statement 
    module_name: 
    (dotted_name 
      (identifier) @module )
    name: _ )
  (import_statement 
    name: 
    (aliased_import 
      name: 
      (dotted_name 
        (identifier) @module)
      alias: _)) ]
 (#match? @module "\(pandas\|polars\)"))
