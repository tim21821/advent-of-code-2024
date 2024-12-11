using Memoization

@memoize function getnumberofstones(stone::Int, blinksleft::Int)
    if blinksleft == 0
        return 1
    end

    if stone == 0
        return getnumberofstones(1, blinksleft - 1)
    else
        stonestr = string(stone)
        if iseven(length(stonestr))
            mid = length(stonestr) ÷ 2
            return getnumberofstones(parse(Int, stonestr[1:mid]), blinksleft - 1) +
                   getnumberofstones(parse(Int, stonestr[mid+1:end]), blinksleft - 1)
        else
            return getnumberofstones(stone * 2024, blinksleft - 1)
        end
    end
end

function part1()
    input = open("input/day11.txt") do f
        return readline(f)
    end

    stones = parse.(Int, split(input))
    return sum(stone -> getnumberofstones(stone, 25), stones)
end

function part2()
    input = open("input/day11.txt") do f
        return readline(f)
    end

    stones = parse.(Int, split(input))
    return sum(stone -> getnumberofstones(stone, 75), stones)
end
