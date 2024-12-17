function getcombooperand(operand::Int, registers::Dict{Char,Int})
    if operand >= 0 && operand <= 3
        return operand
    elseif operand == 4
        return registers['A']
    elseif operand == 5
        return registers['B']
    elseif operand == 6
        return registers['C']
    end
end

function runprogram!(program::Vector{Int}, registers::Dict{Char,Int})
    output = Vector{Int}()
    instructionpointer = 1
    while checkbounds(Bool, program, instructionpointer)
        instruction = program[instructionpointer]
        operand = program[instructionpointer+1]
        if instruction == 0
            combo = getcombooperand(operand, registers)
            registers['A'] = registers['A'] ÷ 2^combo
        elseif instruction == 1
            registers['B'] = registers['B'] ⊻ operand
        elseif instruction == 2
            registers['B'] = getcombooperand(operand, registers) % 8
        elseif instruction == 3
            if registers['A'] != 0
                instructionpointer = operand + 1
                continue
            end
        elseif instruction == 4
            registers['B'] = registers['B'] ⊻ registers['C']
        elseif instruction == 5
            out = getcombooperand(operand, registers) % 8
            push!(output, out)
        elseif instruction == 6
            combo = getcombooperand(operand, registers)
            registers['B'] = registers['A'] ÷ 2^combo
        elseif instruction == 7
            combo = getcombooperand(operand, registers)
            registers['C'] = registers['A'] ÷ 2^combo
        end
        instructionpointer += 2
    end
    return output
end

function part1()
    lines = open("input/day17.txt") do f
        return readlines(f)
    end

    registers = Dict{Char,Int}()
    registers['A'] = parse(Int, split(lines[1], ": ")[2])
    registers['B'] = parse(Int, split(lines[2], ": ")[2])
    registers['C'] = parse(Int, split(lines[3], ": ")[2])
    program = parse.(Int, split(split(lines[5], ": ")[2], ','))
    
    output = runprogram!(program, registers)
    return join(output, ',')
end

function part2()
    lines = open("input/day17.txt") do f
        return readlines(f)
    end

    originalregisters = Dict{Char,Int}()
    originalregisters['A'] = parse(Int, split(lines[1], ": ")[2])
    originalregisters['B'] = parse(Int, split(lines[2], ": ")[2])
    originalregisters['C'] = parse(Int, split(lines[3], ": ")[2])

    program = parse.(Int, split(split(lines[5], ": ")[2], ','))
    a = 1
    while a <= typemax(Int)
        registers = copy(originalregisters)
        registers['A'] = a
        output = runprogram!(program, registers)
        if output == program
            return a
        elseif length(output) < length(program)
            a *= 8
        else
            lastdiff = findlast(i -> output[i] != program[i], eachindex(output))
            a += 8^(lastdiff - 1)
        end
    end
end
