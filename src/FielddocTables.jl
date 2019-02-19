module FielddocTables

using DocStringExtensions, PrettyTables
import DocStringExtensions: Abbreviation, format

export FIELDDOCTABLE


struct TypeFieldMetadata{L,T,F} <: Abbreviation 
    labels::L
    functions::T
    tableformat::F
    fenced::Bool
end

TypeFieldMetadata(labels::L, functions::T; tableformat=PrettyTableFormat(markdown), fenced=false) where {L,T} =
    TypeFieldMetadata{L,T,typeof(tableformat)}(labels, functions, tableformat, fenced)

const FIELDDOCTABLE = TypeFieldMetadata

function format(metaformat::TypeFieldMetadata, buf, doc)
    local docs = get(doc.data, :fields, Dict())
    local binding = doc.data[:binding]
    local object = Docs.resolve(binding)
    # On 0.7 fieldnames() on an abstract type throws an error. We then explicitly return
    # an empty vector to be consistent with the behaviour on v0.6.
    local fields = isabstracttype(object) ? Symbol[] : fieldnames(object)


    if !isempty(fields)


        # Fieldnames and passed in functions
        colnames = [:Field, metaformat.labels...]
        data = hcat([fields...], ([string.(f(object))...] for f in metaformat.functions)...)

        fielddocs = []
        for field in fields
            if haskey(docs, field) && isa(docs[field], AbstractString)
                for line in split(docs[field], "\n")
                    push!(fielddocs, isempty(line) ? "" : "    ", rstrip(line))
                end
            end
        end
        if any(d -> d != "", fielddocs)
            data = hcat(data, fielddocs)
            colnames = [colnames..., :Docs]
        end

        println(buf)
        metaformat.fenced && println(buf, "```")
        pretty_table(buf, data, colnames, metaformat.tableformat)
        metaformat.fenced && println(buf, "```")
        println(buf)
    end
    return nothing
end

end # module
