function getblocks(diskmap::Vector{T}) where T <: Integer
    blocks = Vector{T}()
    empty = false
    id = zero(T)
    for count in diskmap
        if empty
            append!(blocks, [-one(T) for _ in 1:count])
        else
            append!(blocks, [id for _ in 1:count])
            id += one(T)
        end
        empty = !empty
    end
    return blocks
end

function moveblocks1!(blocks::Vector{T}) where T <: Integer
    firstempty = findfirst(x -> x == -1, blocks)
    lastnotempty = findlast(x -> x != -1, blocks)
    while firstempty < lastnotempty
        blocks[firstempty], blocks[lastnotempty] = blocks[lastnotempty], blocks[firstempty]
        firstempty = findfirst(x -> x == -1, blocks)
        lastnotempty = findlast(x -> x != -1, blocks)
    end
end

function moveblocks2!(blocks::Vector{T}) where T <: Integer
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

function getchecksum(blocks::Vector{T}) where T <: Integer
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

    diskmap = parse.(Int16, collect(input))
    blocks = getblocks(diskmap)
    moveblocks1!(blocks)
    return getchecksum(blocks)
end

function part2()
    input = open("input/day9.txt") do f
        return readline(f)
    end

    diskmap = parse.(Int16, collect(input))
    blocks = getblocks(diskmap)
    moveblocks2!(blocks)
    return getchecksum(blocks)
end
