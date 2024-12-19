using DataStructures
using StaticArrays

const WIDTH = 70
const HEIGHT = 70
const UP = @SVector [0, -1]
const DOWN = @SVector [0, 1]
const RIGHT = @SVector [1, 0]
const LEFT = @SVector [-1, 0]
const START = @SVector [0, 0]
const GOAL = @SVector [WIDTH, HEIGHT]

function getsteps(bytelocations::Set{SVector{2,Int}})
    queue = Queue{Tuple{SVector{2,Int},Int}}()
    enqueue!(queue, (START, 0))
    visited = Set{SVector{2,Int}}()
    push!(visited, START)
    while !isempty(queue)
        currentposition, steps = dequeue!(queue)
        if currentposition == GOAL
            return steps
        end

        up = currentposition + UP
        if up[2] >= 0 && !(up in bytelocations) && !(up in visited)
            enqueue!(queue, (up, steps + 1))
            push!(visited, up)
        end

        down = currentposition + DOWN
        if down[2] <= HEIGHT && !(down in bytelocations) && !(down in visited)
            enqueue!(queue, (down, steps + 1))
            push!(visited, down)
        end

        right = currentposition + RIGHT
        if right[1] <= WIDTH && !(right in bytelocations) && !(right in visited)
            enqueue!(queue, (right, steps + 1))
            push!(visited, right)
        end

        left = currentposition + LEFT
        if left[1] >= 0 && !(left in bytelocations) && !(left in visited)
            enqueue!(queue, (left, steps + 1))
            push!(visited, left)
        end
    end
    return nothing
end

function part1()
    lines = open("input/day18.txt") do f
        return readlines(f)
    end

    fallingbytes = 1024
    bytelocations = Set{SVector{2,Int}}()
    for i in 1:fallingbytes
        position = SVector{2}(parse.(Int, split(lines[i], ',')))
        push!(bytelocations, position)
    end

    return getsteps(bytelocations)
end

function part2()
    lines = open("input/day18.txt") do f
        return readlines(f)
    end

    bytelocations = Set{SVector{2,Int}}()
    for i in eachindex(lines)
        position = SVector{2}(parse.(Int, split(lines[i], ',')))
        push!(bytelocations, position)
        if isnothing(getsteps(bytelocations))
            return lines[i]
        end
    end
end
