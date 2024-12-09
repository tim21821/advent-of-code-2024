function getblocks(diskmap::Vector{Int})
    blocks = Vector{Int}()
    empty = false
    id = 0
    for count in diskmap
        if empty
            append!(blocks, [-1 for _ in 1:count])
        else
            append!(blocks, [id for _ in 1:count])
            id += 1
        end
        empty = !empty
    end
    return blocks
end

function moveblocks1!(blocks::Vector{Int})
    firstempty = findfirst(x -> x == -1, blocks)
    lastnotempty = findlast(x -> x != -1, blocks)
    while firstempty < lastnotempty
        blocks[firstempty], blocks[lastnotempty] = blocks[lastnotempty], blocks[firstempty]
        firstempty = findfirst(x -> x == -1, blocks)
        lastnotempty = findlast(x -> x != -1, blocks)
    end
end

function moveblocks2!(blocks::Vector{Int})
    maxid = maximum(blocks)
    for id in maxid:-1:0
        blockindices = findall(x -> x == id, blocks)
        len = length(blockindices)
        for emptyindex in 1:minimum(blockindices)-1
            if all(x -> x == -1, blocks[emptyindex:emptyindex+len-1])
                blocks[blockindices], blocks[emptyindex:emptyindex+len-1] =
                    blocks[emptyindex:emptyindex+len-1], blocks[blockindices]
                break
            end
        end
    end
end

function getchecksum(blocks::Vector{Int})
    checksum = 0
    for (i, block) in enumerate(blocks)
        checksum += max((i - 1) * block, 0)
    end
    return checksum
end

function part1()
    input = open("input/day9.txt") do f
        return readline(f)
    end

    diskmap = parse.(Int, collect(input))
    blocks = getblocks(diskmap)
    moveblocks1!(blocks)
    return getchecksum(blocks)
end

function part2()
    input = open("input/day9.txt") do f
        return readline(f)
    end

    diskmap = parse.(Int, collect(input))
    blocks = getblocks(diskmap)
    moveblocks2!(blocks)
    return getchecksum(blocks)
end
