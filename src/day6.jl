using DataStructures

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
    elseif currentdirection == LEFT
        return UP
    end
end

function part1()
    lines = open("input/day6.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    currentposition = findfirst(c -> c == '^', grid)
    currentdirection = UP
    visited = Set{CartesianIndex{2}}()
    while true
        push!(visited, currentposition)
        nextposition = currentposition + currentdirection
        if !checkbounds(Bool, grid, nextposition)
            return length(visited)
        elseif grid[nextposition] == '#'
            currentdirection = turnright(currentdirection)
        else
            currentposition = nextposition
        end
    end
end

function part2()
    lines = open("input/day6.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    startposition = findfirst(c -> c == '^', grid)
    looppossibilities = 0
    for i in eachindex(grid)
        println(i)
        currentgrid = copy(grid)
        if currentgrid[i] == '#' || currentgrid[i] == '^'
            continue
        end
        currentgrid[i] = '#'
        currentposition = startposition
        currentdirection = UP
        visiteddirections = DefaultDict{CartesianIndex{2},Vector{CartesianIndex{2}}}(
            () -> Vector{CartesianIndex{2}}(),
        )
        while true
            if currentdirection in visiteddirections[currentposition]
                looppossibilities += 1
                break
            end
            push!(visiteddirections[currentposition], currentdirection)
            nextposition = currentposition + currentdirection
            if !checkbounds(Bool, grid, nextposition)
                break
            elseif currentgrid[nextposition] == '#'
                currentdirection = turnright(currentdirection)
            else
                currentposition = nextposition
            end
        end
    end
    return looppossibilities
end
