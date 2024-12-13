using DataStructures

const UP = CartesianIndex(-1, 0)
const DOWN = CartesianIndex(1, 0)
const RIGHT = CartesianIndex(0, 1)
const LEFT = CartesianIndex(0, -1)

function findregions(grid::Matrix{Char})
    regions = Vector{Set{CartesianIndex{2}}}()
    for index in CartesianIndices(grid)
        if any(region -> index in region, regions)
            continue
        end

        push!(regions, findregion(grid, index))
    end
    return regions
end

function findregion(grid::Matrix{Char}, startingposition::CartesianIndex{2})
    currentplant = grid[startingposition]
    region = Set{CartesianIndex{2}}()
    queue = Queue{CartesianIndex{2}}()
    enqueue!(queue, startingposition)
    while !isempty(queue)
        currentposition = dequeue!(queue)
        if grid[currentposition] != currentplant
            continue
        end
        push!(region, currentposition)
        up = currentposition + UP
        if !(up in region) && checkbounds(Bool, grid, up) && !(up in queue)
            enqueue!(queue, up)
        end
        down = currentposition + DOWN
        if !(down in region) && checkbounds(Bool, grid, down) && !(down in queue)
            enqueue!(queue, down)
        end
        right = currentposition + RIGHT
        if !(right in region) && checkbounds(Bool, grid, right) && !(right in queue)
            enqueue!(queue, right)
        end
        left = currentposition + LEFT
        if !(left in region) && checkbounds(Bool, grid, left) && !(left in queue)
            enqueue!(queue, left)
        end
    end
    return region
end

getarea(region::Set{CartesianIndex{2}}) = length(region)

function getperimeter(region::Set{CartesianIndex{2}})
    perimeter = 0
    for tile in region
        up = tile + UP
        if !(up in region)
            perimeter += 1
        end
        down = tile + DOWN
        if !(down in region)
            perimeter += 1
        end
        left = tile + LEFT
        if !(left in region)
            perimeter += 1
        end
        right = tile + RIGHT
        if !(right in region)
            perimeter += 1
        end
    end
    return perimeter
end
function part1()
    lines = open("input/day12.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    regions = findregions(grid)
    return sum(region -> getarea(region) * getperimeter(region), regions)
end

