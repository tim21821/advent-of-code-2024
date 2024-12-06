using DataStructures
using Folds

const UP = CartesianIndex(-1, 0)
const DOWN = CartesianIndex(1, 0)
const RIGHT = CartesianIndex(0, 1)
const LEFT = CartesianIndex(0, -1)

function turnright(currentdirection::CartesianIndex{2})
    if currentdirection == UP
        return RIGHT
    elseif currentdirection == RIGHT
        return DOWN
    elseif currentdirection == DOWN
        return LEFT
    else
        return UP
    end
end

function getpath(grid::Matrix{Char}, position::CartesianIndex{2})
    direction = UP
    visited = Set{CartesianIndex{2}}()
    while true
        push!(visited, position)
        nextposition = position + direction
        if !checkbounds(Bool, grid, nextposition)
            return visited
        elseif grid[nextposition] == '#'
            direction = turnright(direction)
        else
            position = nextposition
        end
    end
end

function createsloop(
    grid::Matrix{Char},
    pos::CartesianIndex{2},
    startposition::CartesianIndex{2},
)
    if grid[pos] == '#' || grid[pos] == '^'
        return false
    end
    currentposition = startposition
    currentdirection = UP
    visiteddirections = DefaultDict{CartesianIndex{2},Vector{CartesianIndex{2}}}(
        () -> Vector{CartesianIndex{2}}(),
    )
    while true
        if currentdirection in visiteddirections[currentposition]
            return true
        end
        push!(visiteddirections[currentposition], currentdirection)
        nextposition = currentposition + currentdirection
        if !checkbounds(Bool, grid, nextposition)
            return false
        elseif grid[nextposition] == '#' || nextposition == pos
            currentdirection = turnright(currentdirection)
        else
            currentposition = nextposition
        end
    end
end

function part1()
    lines = open("input/day6.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    currentposition = findfirst(c -> c == '^', grid)
    return length(getpath(grid, currentposition))
end

function part2()
    lines = open("input/day6.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    startposition = findfirst(c -> c == '^', grid)
    path = getpath(grid, startposition)
    return Folds.count(pos -> createsloop(grid, pos, startposition), path)
end
