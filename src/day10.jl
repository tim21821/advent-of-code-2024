using DataStructures

const UP = CartesianIndex(-1, 0)
const DOWN = CartesianIndex(1, 0)
const RIGHT = CartesianIndex(0, 1)
const LEFT = CartesianIndex(0, -1)

function getscore(grid::Matrix{T}, trailhead::CartesianIndex{2}) where {T<:Integer}
    queue = Queue{CartesianIndex{2}}()
    enqueue!(queue, trailhead)
    reachable = Set{CartesianIndex{2}}()
    while !isempty(queue)
        current = dequeue!(queue)
        if grid[current] == 9
            push!(reachable, current)
            continue
        end
        up = current + UP
        if checkbounds(Bool, grid, up) && grid[up] - grid[current] == 1
            enqueue!(queue, up)
        end
        down = current + DOWN
        if checkbounds(Bool, grid, down) && grid[down] - grid[current] == 1
            enqueue!(queue, down)
        end
        right = current + RIGHT
        if checkbounds(Bool, grid, right) && grid[right] - grid[current] == 1
            enqueue!(queue, right)
        end
        left = current + LEFT
        if checkbounds(Bool, grid, left) && grid[left] - grid[current] == 1
            enqueue!(queue, left)
        end
    end
    return length(reachable)
end

function getrating(grid::Matrix{T}, trailhead::CartesianIndex{2}) where {T<:Integer}
    rating = 0
    queue = Queue{CartesianIndex{2}}()
    enqueue!(queue, trailhead)
    while !isempty(queue)
        current = dequeue!(queue)
        if grid[current] == 9
            rating += 1
            continue
        end
        up = current + UP
        if checkbounds(Bool, grid, up) && grid[up] - grid[current] == 1
            enqueue!(queue, up)
        end
        down = current + DOWN
        if checkbounds(Bool, grid, down) && grid[down] - grid[current] == 1
            enqueue!(queue, down)
        end
        right = current + RIGHT
        if checkbounds(Bool, grid, right) && grid[right] - grid[current] == 1
            enqueue!(queue, right)
        end
        left = current + LEFT
        if checkbounds(Bool, grid, left) && grid[left] - grid[current] == 1
            enqueue!(queue, left)
        end
    end
    return rating
end

function part1()
    lines = open("input/day10.txt") do f
        return readlines(f)
    end

    grid = parse.(UInt8, stack(collect.(lines); dims = 1))
    trailheads = findall(x -> x == 0, grid)
    return sum(trailhead -> getscore(grid, trailhead), trailheads)
end

function part2()
    lines = open("input/day10.txt") do f
        return readlines(f)
    end

    grid = parse.(UInt8, stack(collect.(lines); dims = 1))
    trailheads = findall(x -> x == 0, grid)
    return sum(trailhead -> getrating(grid, trailhead), trailheads)
end
