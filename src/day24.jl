function getoutput(wires::Dict{String,Bool})
    out = ""
    i = 0
    wire = "z00"
    while wire in keys(wires)
        if wires[wire]
            out = '1' * out
        else
            out = '0' * out
        end
        i += 1
        wire = "z$(lpad(i, 2, '0'))"
    end
    return parse(Int, "0b$out")
end

function part1()
    lines = open("input/day24.txt") do f
        return readlines(f)
    end

    i = 1
    wires = Dict{String,Bool}()
    while lines[i] != ""
        wire, value = split(lines[i], ": ")
        wires[wire] = value == "1"
        i += 1
    end

    instructions = lines[i+1:end]
    while !isempty(instructions)
        notexecuted = Vector{String}()
        for instruction in instructions
            if occursin("AND", instruction)
                gate, wire = split(instruction, " -> ")
                wire1, wire2 = split(gate, " AND ")
                if wire1 in keys(wires) && wire2 in keys(wires)
                    wires[wire] = wires[wire1] && wires[wire2]
                else
                    push!(notexecuted, instruction)
                end
            elseif occursin("XOR", instruction)
                gate, wire = split(instruction, " -> ")
                wire1, wire2 = split(gate, " XOR ")
                if wire1 in keys(wires) && wire2 in keys(wires)
                    wires[wire] = wires[wire1] ⊻ wires[wire2]
                else
                    push!(notexecuted, instruction)
                end
            else
                gate, wire = split(instruction, " -> ")
                wire1, wire2 = split(gate, " OR ")
                if wire1 in keys(wires) && wire2 in keys(wires)
                    wires[wire] = wires[wire1] || wires[wire2]
                else
                    push!(notexecuted, instruction)
                end
            end
        end
        instructions = notexecuted
    end
    return getoutput(wires)
end
