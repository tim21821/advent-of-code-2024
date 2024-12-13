using StaticArrays

const BUTTON_RE = r"Button [A|B]: X\+(\d+), Y\+(\d+)"
const PRIZE_RE = r"Prize: X=(\d+), Y=(\d+)"

checkpath1(path::SVector{2,Float64}) = all(isinteger, path) && all(path .<= 100)

checkpath2(path::SVector{2,Float64}) = all(isinteger, path)

function part1()
    lines = open("input/day13.txt") do f
        return readlines(f)
    end

    tokens = 0
    i = 1
    while checkbounds(Bool, lines, i)
        m = match(BUTTON_RE, lines[i])
        a = SVector{2}(parse.(Int, m.captures))
        i += 1
        m = match(BUTTON_RE, lines[i])
        b = SVector{2}(parse.(Int, m.captures))
        i += 1
        m = match(PRIZE_RE, lines[i])
        prize = SVector{2}(parse.(Int, m.captures))
        buttonmatrix = hcat(a, b)
        path = buttonmatrix \ prize
        if checkpath1(path)
            tokens += trunc(Int, 3 * path[1] + path[2])
        end
        i += 2
    end
    return tokens
end

function part2()
    lines = open("input/day13.txt") do f
        return readlines(f)
    end

    tokens = 0
    i = 1
    while checkbounds(Bool, lines, i)
        m = match(BUTTON_RE, lines[i])
        a = SVector{2}(parse.(Int, m.captures))
        i += 1
        m = match(BUTTON_RE, lines[i])
        b = SVector{2}(parse.(Int, m.captures))
        i += 1
        m = match(PRIZE_RE, lines[i])
        prize = SVector{2}(parse.(Int, m.captures))
        prize = prize + SVector{2}([10000000000000, 10000000000000])
        buttonmatrix = hcat(a, b)
        path = buttonmatrix \ prize
        if checkpath2(path)
            tokens += trunc(Int, 3 * path[1] + path[2])
        end
        i += 2
    end
    return tokens
end
