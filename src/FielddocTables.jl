module FielddocTables

using DocStringExtensions, PrettyTables
import DocStringExtensions: Abbreviation, format

export FielddocTable

struct FielddocTable{L,T,F} <: Abbreviation 
    labels::L
    functions::T
    tableformat::F
    fenced::Bool
end

FielddocTable(labels::L, functions::T; tableformat=PrettyTableFormat(markdown), fenced=false) where {L,T} =
    FielddocTable{L,T,typeof(tableformat)}(labels, functions, tableformat, fenced)

function format(doctable::FielddocTable, buf, doc)
    println("Nooooooooooooooooooooooooooooooooooooooooow?????????")
    local docs = get(doc.data, :fields, Dict())
    local binding = doc.data[:binding]
    local object = Docs.resolve(binding)
    # On 0.7 fieldnames() on an abstract type throws an error. We then explicitly return
    # an empty vector to be consistent with the behaviour on v0.6.
    local fields = isabstracttype(object) ? Symbol[] : fieldnames(object)

    if !isempty(fields)


        # Fieldnames and passed in functions
        colnames = [:Field, doctable.labels...]
        data = hcat([fields...], ([safestring.(f(object))...] for f in doctable.functions)...)

        fielddocs = []
        for field in fields
            if haskey(docs, field) && isa(docs[field], AbstractString)
                for line in split(docs[field], "\n")
                    fielddoc = isempty(line) ? "" : rstrip(line)
                end
            else
                fielddoc = ""
            end
            push!(fielddocs, fielddoc)
        end
        if any(d -> d != "", fielddocs)
            data = hcat(data, fielddocs)
            colnames = [colnames..., :Docs]
        end

        println(buf)
        doctable.fenced && println(buf, "```")
        pretty_table(buf, data, colnames, doctable.tableformat)
        doctable.fenced && println(buf, "```")
        println(buf)
    end
    return nothing
end

safestring(::Nothing) = "nothing"
safestring(s) = string(s)

end # module
