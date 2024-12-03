const MUL_REGEX = r"mul\((\d\d?\d?),(\d\d?\d?)\)"

const DONT_REGEX = r"don't\(\).*?\n?.*?do\(\)"

function part1()
    input = open("input/day3.txt") do f
        return read(f, String)
    end

    sumofvalid = 0
    for m in eachmatch(MUL_REGEX, input)
        sumofvalid += parse(Int, m[1]) * parse(Int, m[2])
    end
    return sumofvalid
end

function part2()
    input = open("input/day3.txt") do f
        return read(f, String)
    end

    sumofvalid = 0
    enabled = replace(input, DONT_REGEX => "")
    for m in eachmatch(MUL_REGEX, enabled)
        sumofvalid += parse(Int, m[1]) * parse(Int, m[2])
    end
    return sumofvalid
end
