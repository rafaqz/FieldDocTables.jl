# FieldDocTables

[![Build Status](https://travis-ci.org/rafaqz/FieldDocTables.jl.svg?branch=master)](https://travis-ci.org/rafaqz/FieldDocTables.jl)
[![codecov.io](http://codecov.io/github/rafaqz/FieldDocTables.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/FieldDocTables.jl?branch=master)

FieldDocTables uses [DocStringExtensions.jl](https://github.com/JuliaDocs/DocStringExtensions.jl)
and [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) to print field names and field
docs in a table in the docs for a type (defaults to unfenced markdown).

But the main reason to use this package is to add additional columns to the
field documentation, such as from [FieldMetadata.jl](https://github.com/rafaqz/FieldMetadata.jl).



```julia
using FieldDocTables, FieldMetadata

import FieldMetadata: @default, default, @bounds, bounds, @description, description

# Declare the doc abbreviation for your doc table
const FIELDDOCTABLE = FieldDocTable((Description=description, Default=default, Bounds=bounds))

""
The docs and metadata for this type are printed as a markdown table:
$(FIELDDOCTABLE)
"""
@description @bounds @default mutable struct TestStruct
   "Field a docs"
   a::Int     | 2   | (1, 10)     | "an Int"
   "Field b docs"
   b::Float64 | 4.0 | (2.0, 20.0) | "a Float "
end

help?> TestStruct
search: TestStruct

  The docs and metadata for this type are printed as a markdown table:

Field Description Default      Bounds    Docs
––––– ––––––––––– ––––––– ––––––––––– –––––––
    a      an Int       2     (1, 10) Field a
    b     a Float     4.0 (2.0, 20.0) Field b
```

You could additionally set the truncation length for each field, or use another
table format. Table formats besides markdown should be fenced:

```julia
const FIELDDOCTABLE = FieldDocTable((:Description=description, :Default=default, :Bounds=bounds);
                                    truncation=(100,40,70),
                                    tableformat=PrettyTableFormat(unicode_rounded),
                                    fenced=true)
```

Note that formats besides markdown will not translate to good html tables in browser documentation.

Custom functions can also be passed to the field doc constructor `FieldDocTable()`. They must accept 
a type argument and return a vector or tuple of the same length as the number of fields in the type:

```julia
somemethod(::Type{<:TypeToDocument}) = ("doc", "for", "each", "field")
```
