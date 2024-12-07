concatenate(n::Int, m::Int) = n * 10^(trunc(Int, ceil(log10(m + 1)))) + m

function getpossibleresults1(equation::Vector{Int})
    if length(equation) == 1
        return Set(equation[1])
    end

    results = getpossibleresults1(equation[1:end-1])
    additionresults = equation[end] .+ results
    multiplicationresults = equation[end] .* results
    return union(additionresults, multiplicationresults)
end

function getpossibleresults2(equation::Vector{Int})
    if length(equation) == 1
        return Set(equation[1])
    end

    results = getpossibleresults2(equation[1:end-1])
    additionresults = equation[end] .+ results
    multiplicationresults = equation[end] .* results
    concatenationresults = concatenate.(results, equation[end])
    return union(additionresults, multiplicationresults, concatenationresults)
end

function getsolvedresult1(line::AbstractString)
    l, r = split(line, ": ")
    result = parse(Int, l)
    equation = parse.(Int, split(r))
    if result in getpossibleresults1(equation)
        return result
    else
        return 0
    end
end

function getsolvedresult2(line::AbstractString)
    l, r = split(line, ": ")
    result = parse(Int, l)
    equation = parse.(Int, split(r))
    if result in getpossibleresults2(equation)
        return result
    else
        return 0
    end
end

function part1()
    lines = open("input/day7.txt") do f
        return readlines(f)
    end

    return sum(getsolvedresult1, lines)
end

function part2()
    lines = open("input/day7.txt") do f
        return readlines(f)
    end

    return sum(getsolvedresult2, lines)
end
