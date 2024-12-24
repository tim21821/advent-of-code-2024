using StaticArrays

const UP = @SVector [0, -1]
const DOWN = @SVector [0, 1]
const LEFT = @SVector [-1, 0]
const RIGHT = @SVector [1, 0]
const DIRECTIONS =
    Dict{Char,SVector{2,Int}}('^' => UP, 'v' => DOWN, '<' => LEFT, '>' => RIGHT)

getgps(coordinates::SVector{2,Int}) = 100 * (coordinates[2] - 1) + coordinates[1] - 1


function part1()
    lines = open("input/day15.txt") do f
        return readlines(f)
    end

    i = 1
    robot = @SVector [0, 0]
    boxes = Set{SVector{2,Int}}()
    walls = Set{SVector{2,Int}}()
    while lines[i] != ""
        for j in eachindex(lines[i])
            if lines[i][j] == '@'
                robot = @SVector [j, i]
            elseif lines[i][j] == 'O'
                push!(boxes, @SVector [j, i])
            elseif lines[i][j] == '#'
                push!(walls, @SVector [j, i])
            end
        end
        i += 1
    end
    i += 1
    moves = ""
    while checkbounds(Bool, lines, i)
        moves = moves * lines[i]
        i += 1
    end
    for move in moves
        direction = DIRECTIONS[move]
        boxestomove = Vector{SVector{2,Int}}()
        steps = 1
        while true
            position = robot + steps * direction
            if position in boxes
                push!(boxestomove, position)
            elseif position in walls
                @goto nextmove
            else
                break
            end
            steps += 1
        end
        robot = robot + direction
        for box in reverse(boxestomove)
            delete!(boxes, box)
            push!(boxes, box + direction)
        end
        @label nextmove
    end

    return sum(getgps, boxes)
end
