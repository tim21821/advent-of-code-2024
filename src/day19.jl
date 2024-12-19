using Memoization

function canbuild(design::AbstractString, towels::Vector{T}) where {T<:AbstractString}
    if design == ""
        return true
    end

    foundarrangement = false
    for towel in towels
        if startswith(design, towel)
            foundarrangement =
                foundarrangement || canbuild(design[length(towel)+1:end], towels)
        end
    end
    return foundarrangement
end

@memoize function waystobuild(
    design::AbstractString,
    towels::Vector{T},
) where {T<:AbstractString}
    if design == ""
        return 1
    end

    ways = 0
    for towel in towels
        if startswith(design, towel)
            ways = ways + waystobuild(design[length(towel)+1:end], towels)
        end
    end
    return ways
end

function part1()
    lines = open("input/day19.txt") do f
        return readlines(f)
    end

    towels = split(lines[1], ", ")
    return count(line -> canbuild(line, towels), lines[3:end])
end

function part2()
    lines = open("input/day19.txt") do f
        return readlines(f)
    end

    towels = split(lines[1], ", ")
    return sum(line -> waystobuild(line, towels), lines[3:end])
end
