const FURTHER_LETTERS = ['M', 'A', 'S']

const DIRECTIONS = [
    CartesianIndex(1, 0),
    CartesianIndex(-1, 0),
    CartesianIndex(0, 1),
    CartesianIndex(0, -1),
    CartesianIndex(1, 1),
    CartesianIndex(1, -1),
    CartesianIndex(-1, 1),
    CartesianIndex(-1, -1),
]

checkdirection(grid::Matrix{Char}, xpos::CartesianIndex{2}, direction::CartesianIndex{2}) =
    all(
        i ->
            checkbounds(Bool, grid, xpos + i * direction) &&
                grid[xpos+i*direction] == FURTHER_LETTERS[i],
        1:3,
    )

countadjacentxmas(grid::Matrix{Char}, xpos::CartesianIndex{2}) =
    count(direction -> checkdirection(grid, xpos, direction), DIRECTIONS)

function buildsx_mas(grid::Matrix{Char}, apos::CartesianIndex{2})
    upperleft = apos + CartesianIndex(-1, -1)
    lowerright = apos + CartesianIndex(1, 1)
    lowerleft = apos + CartesianIndex(1, -1)
    upperright = apos + CartesianIndex(-1, 1)
    if any(
        pos -> !checkbounds(Bool, grid, pos),
        [upperleft, lowerright, lowerleft, upperright],
    )
        return false
    end
    return (
        (grid[upperleft] == 'M' && grid[lowerright] == 'S') ||
        (grid[upperleft] == 'S' && grid[lowerright] == 'M')
    ) && (
        (grid[lowerleft] == 'M' && grid[upperright] == 'S') ||
        (grid[lowerleft] == 'S' && grid[upperright] == 'M')
    )
end

function part1()
    lines = open("input/day4.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    xpositions = findall(e -> e == 'X', grid)
    xmascount = 0
    for pos in xpositions
        xmascount += countadjacentxmas(grid, pos)
    end
    return xmascount
end

function part2()
    lines = open("input/day4.txt") do f
        return readlines(f)
    end

    grid = stack(collect.(lines); dims = 1)
    apositions = findall(e -> e == 'A', grid)
    return count(pos -> buildsx_mas(grid, pos), apositions)
end
