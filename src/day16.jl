using DataStructures

const UP = CartesianIndex(-1, 0)
const DOWN = CartesianIndex(1, 0)
const RIGHT = CartesianIndex(0, 1)
const LEFT = CartesianIndex(0, -1)

struct State
    position::CartesianIndex{2}
    direction::CartesianIndex{2}
    score::Int
end

struct Path
    position::CartesianIndex{2}
    direction::CartesianIndex{2}
    score::Int
    visited::Set{CartesianIndex{2}}
end

function turnclockwise(direction::CartesianIndex{2})
    if direction == UP
        return RIGHT
    elseif direction == RIGHT
        return DOWN
    elseif direction == DOWN
        return LEFT
    else
        return UP
    end
end

function turnanticlockwise(direction::CartesianIndex{2})
    if direction == UP
        return LEFT
    elseif direction == LEFT
        return DOWN
    elseif direction == DOWN
        return RIGHT
    else
        return UP
    end
end

function part1()
    lines = open("input/day16.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    start = findfirst(c -> c == 'S', grid)
    goal = findfirst(c -> c == 'E', grid)
    queue = PriorityQueue{State,Int}()
    enqueue!(queue, State(start, RIGHT, 0) => 0)
    visited = Set{Tuple{CartesianIndex{2},CartesianIndex{2}}}()
    while !isempty(queue)
        current = dequeue!(queue)
        push!(visited, (current.position, current.direction))

        if current.position == goal
            return current.score
        end

        forward = current.position + current.direction
        forwardstate = State(forward, current.direction, current.score + 1)
        if checkbounds(Bool, grid, forward) &&
           grid[forward] != '#' &&
           !(forwardstate in keys(queue)) &&
           !((forward, current.direction) in visited)
            enqueue!(queue, forwardstate => current.score + 1)
        end

        clockwise =
            State(current.position, turnclockwise(current.direction), current.score + 1000)
        if !(clockwise in keys(queue)) &&
           !((clockwise.position, clockwise.direction) in visited)
            enqueue!(queue, clockwise => current.score + 1000)
        end

        anticlockwise = State(
            current.position,
            turnanticlockwise(current.direction),
            current.score + 1000,
        )
        if !(anticlockwise in keys(queue)) &&
           !((anticlockwise.position, anticlockwise.direction) in visited)
            enqueue!(queue, anticlockwise => current.score + 1000)
        end
    end
end

function part2()
    lines = open("input/day16.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    start = findfirst(c -> c == 'S', grid)
    goal = findfirst(c -> c == 'E', grid)
    queue = PriorityQueue{Path,Int}()
    enqueue!(queue, Path(start, RIGHT, 0, Set{CartesianIndex{2}}()) => 0)
    visited = Set{Tuple{CartesianIndex{2},CartesianIndex{2}}}()
    bestpaths = Vector{Path}()
    bestscore = typemax(Int)
    while !isempty(queue)
        currentpath = dequeue!(queue)
        push!(visited, (currentpath.position, currentpath.direction))

        if currentpath.score > bestscore
            break
        end
        if currentpath.position == goal
            push!(bestpaths, currentpath)
            bestscore = currentpath.score
        end

        forward = currentpath.position + currentpath.direction
        forwardpath = Path(
            forward,
            currentpath.direction,
            currentpath.score + 1,
            currentpath.visited ∪ Set([currentpath.position]),
        )
        if checkbounds(Bool, grid, forward) &&
           grid[forward] != '#' &&
           !(forwardpath in keys(queue)) &&
           !((forward, currentpath.direction) in visited)
            enqueue!(queue, forwardpath => currentpath.score + 1)
        end

        clockwise = Path(
            currentpath.position,
            turnclockwise(currentpath.direction),
            currentpath.score + 1000,
            currentpath.visited,
        )
        if !(clockwise in keys(queue)) &&
           !((clockwise.position, clockwise.direction) in visited)
            enqueue!(queue, clockwise => currentpath.score + 1000)
        end

        anticlockwise = Path(
            currentpath.position,
            turnanticlockwise(currentpath.direction),
            currentpath.score + 1000,
            currentpath.visited,
        )
        if !(anticlockwise in keys(queue)) &&
           !((anticlockwise.position, anticlockwise.direction) in visited)
            enqueue!(queue, anticlockwise => currentpath.score + 1000)
        end
    end
    return length(union([path.visited for path in bestpaths]...)) + 1
end
