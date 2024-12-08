using DataStructures
import Base.÷

÷(index::CartesianIndex{2}, d::Int) = CartesianIndex(index[1] ÷ d, index[2] ÷ d)

function getantennapositions(grid::Matrix{Char})
    antennas =
        DefaultDict{Char,Vector{CartesianIndex{2}}}(() -> Vector{CartesianIndex{2}}())
    for index in CartesianIndices(grid)
        c = grid[index]
        if c != '.'
            push!(antennas[c], index)
        end
    end
    return antennas
end

function getantinodes(position1::CartesianIndex{2}, position2::CartesianIndex{2})
    antinode1 = position1 + 2 .* (position2 - position1)
    antinode2 = position2 + 2 .* (position1 - position2)
    return antinode1, antinode2
end

function part1()
    lines = open("input/day8.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    antennas = getantennapositions(grid)

    antinodes = Vector{CartesianIndex{2}}()
    for positions in values(antennas)
        for position1 in positions
            for position2 in positions
                if position1 == position2
                    continue
                end
                antinode1, antinode2 = getantinodes(position1, position2)
                if checkbounds(Bool, grid, antinode1)
                    push!(antinodes, antinode1)
                end
                if checkbounds(Bool, grid, antinode2)
                    push!(antinodes, antinode2)
                end
            end
        end
    end
    return length(unique(antinodes))
end

function part2()
    lines = open("input/day8.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    antennas = getantennapositions(grid)

    antinodes = Vector{CartesianIndex{2}}()
    for positions in values(antennas)
        for position1 in positions
            for position2 in positions
                if position1 == position2
                    continue
                end
                vec = position2 - position1
                vec ÷= gcd(vec[1], vec[2])
                i = 1
                while checkbounds(Bool, grid, position1 + i * vec)
                    push!(antinodes, position1 + i * vec)
                    i += 1
                end
                i = -1
                while checkbounds(Bool, grid, position2 + i * vec)
                    push!(antinodes, position2 + i * vec)
                    i -= 1
                end
            end
        end
    end
    return length(unique(antinodes))
end
