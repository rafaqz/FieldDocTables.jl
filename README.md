# FielddocTables

[![Build Status](https://travis-ci.org/rafaqz/FielddocTables.jl.svg?branch=master)](https://travis-ci.org/rafaqz/FielddocTables.jl)
[![Coverage Status](https://coveralls.io/repos/rafaqz/FielddocTables.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/rafaqz/FielddocTables.jl?branch=master)
[![codecov.io](http://codecov.io/github/rafaqz/FielddocTables.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/FielddocTables.jl?branch=master)

FielddocTables uses [DocStringExtensions.jl](https://github.com/JuliaDocs/DocStringExtensions.jl) 
and [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) to print field names and field 
docs in a table in the docs for a type (defaults to unfenced markdown).

But the main reason to use this package is to add additional columns to the
field documentation, such as from [FieldMetadata.jl](https://github.com/rafaqz/FieldMetadata.jl).

Additional column labels and methods can be passed to the field doc
constructor `FielddocTable()`. The method must accept a type and return a
vector or tuple of the same length as the number of fields in the type.

```julia
using FielddocTables, FieldMetadata

import FieldMetadata: @default, default, @limits, limits, @description, @redescription, description

# Declare the doc abbreviation for your doc table
const FIELDDOCTABLE = FielddocTable((Description=description, Default=default, Limits=limits))

"""
The metadata for this type is printed as a markdown table:

$(FIELDDOCTABLE)
"""
@description @limits @default mutable struct TestStruct
   a::Int     | 2   | (1, 10)     | "an Int"
   b::Float64 | 4.0 | (2.0, 20.0) | "a Float "
end

help?> TestStruct
search: TestStruct

  The metadata for this type is printed as a markdown table:

Field Description Default      Limits
––––– ––––––––––– ––––––– –––––––––––
    a      an Int       2     (1, 10)
    b     a Float     4.0 (2.0, 20.0)
```

You could additionally set the truncation length for each field, and use another
table format. Table formats besides markdown should be fenced. 

Note formats besides markdown will not translate to good html tables in browser documentation.

```julia
const FIELDDOCTABLE = FielddocTable((:Description, :Default, :Limits), 
                                   (description, default, limits);
                                   truncation=(100,40,70),
                                   tableformat=PrettyTableFormat(unicode_rounded),
                                   fenced=true)


```
