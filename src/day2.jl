issafeandincreasing(numbers::Vector{Int}) = all(
    i -> numbers[i] < numbers[i+1] && numbers[i+1] - numbers[i] <= 3,
    1:length(numbers)-1,
)

issafeanddecreasing(numbers::Vector{Int}) = all(
    i -> numbers[i] > numbers[i+1] && numbers[i] - numbers[i+1] <= 3,
    1:length(numbers)-1,
)

issafe(report::Vector{Int}) = issafeandincreasing(report) || issafeanddecreasing(report)

function part1()
    lines = open("input/day2.txt") do f
        return readlines(f)
    end

    safecount = 0
    for line in lines
        report = parse.(Int, split(line))
        if issafe(report)
            safecount += 1
        end
    end
    return safecount
end

function part2()
    lines = open("input/day2.txt") do f
        return readlines(f)
    end

    safecount = 0
    for line in lines
        report = parse.(Int, split(line))
        if issafe(report)
            safecount += 1
        else
            if any(i -> issafe(vcat(report[1:i-1], report[i+1:end])), eachindex(report))
                safecount += 1
            end
        end
    end
    return safecount
end
