using DataStructures

function isordered(update::Vector{Int}, beforerules::DefaultDict{Int,Vector{Int}})
    for i in eachindex(update)
        if any(e -> e in update[i+1:end], beforerules[update[i]])
            return false
        end
    end
    return true
end

function swapfirstmismatch!(update::Vector{Int}, beforerules::DefaultDict{Int,Vector{Int}})
    for (i, firstelement) in enumerate(update)
        for j in i+1:length(update)
            secondelement = update[j]
            if secondelement in beforerules[firstelement]
                update[j] = firstelement
                update[i] = secondelement
                return update
            end
        end
    end
    return update
end

function part1()
    lines = open("input/day5.txt") do f
        return readlines(f)
    end

    beforerules = DefaultDict{Int,Vector{Int}}(() -> Vector{Int}())
    i = 1
    while lines[i] != ""
        before, after = parse.(Int, split(lines[i], '|'))
        push!(beforerules[after], before)
        i += 1
    end
    i += 1
    middlesum = 0
    while i <= length(lines)
        update = parse.(Int, split(lines[i], ','))
        if isordered(update, beforerules)
            midindex = (length(update) + 1) ÷ 2
            middlesum += update[midindex]
        end
        i += 1
    end
    return middlesum
end

function part2()
    lines = open("input/day5.txt") do f
        return readlines(f)
    end

    beforerules = DefaultDict{Int,Vector{Int}}(() -> Vector{Int}())
    i = 1
    while lines[i] != ""
        before, after = parse.(Int, split(lines[i], '|'))
        push!(beforerules[after], before)
        i += 1
    end
    i += 1
    middlesum = 0
    while i <= length(lines)
        update = parse.(Int, split(lines[i], ','))
        if isordered(update, beforerules)
            i += 1
            continue
        end
        while !isordered(update, beforerules)
            swapfirstmismatch!(update, beforerules)
        end
        midindex = (length(update) + 1) ÷ 2
        middlesum += update[midindex]
        i += 1
    end
    return middlesum
end
