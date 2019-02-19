module TestFieldDocTables
    using FielddocTables, FieldMetadata, PrettyTables, Test, Markdown

    import FieldMetadata: @default, default, @limits, limits, @description, @redescription, description

    """
    This type tests if FIELDMETADATA is printed as a markdown table.

    $(FIELDDOCTABLE((:Description, :Default, :Limits), (description, default, limits)))
    """
    @description @limits @default mutable struct TestStruct
       " A field doc"
       a::Int     | 2   | (1, 10)     | "an Int"
       b::Float64 | 4.0 | (2.0, 20.0) | "an untyped field"
    end

    @test Markdown.plain(@doc TestStruct) == "This type tests if FIELDMETADATA is printed as a markdown table.\n\n| Field |      Description | Default |      Limits |        Docs |\n| -----:| ----------------:| -------:| -----------:| -----------:|\n|     a |           an Int |     2.0 |     (1, 10) |             |\n|     b | an untyped field |     4.0 | (2.0, 20.0) | A field doc |\n"
end
