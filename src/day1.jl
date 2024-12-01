using DataStructures

function part1()
    lines = open("input/day1.txt") do f
        return readlines(f)
    end

    left = Vector{Int}()
    right = Vector{Int}()
    for line in lines
        n, m = parse.(Int, split(line))
        push!(left, n)
        push!(right, m)
    end

    sort!(left)
    sort!(right)

    totaldistance = 0
    for (n, m) in zip(left, right)
        totaldistance += abs(m - n)
    end
    return totaldistance
end

function part2()
    lines = open("input/day1.txt") do f
        return readlines(f)
    end

    left = Vector{Int}()
    rightcount = DefaultDict{Int,Int}(0)
    for line in lines
        n, m = parse.(Int, split(line))
        push!(left, n)
        rightcount[m] += 1
    end

    similarityscore = 0
    for n in left
        similarityscore += n * rightcount[n]
    end
    return similarityscore
end
