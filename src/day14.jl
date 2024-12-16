using StaticArrays
using Images

const WIDTH = 101
const HEIGHT = 103
const ROBOT_RE = r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)"

mutable struct Robot
    position::Vector{Int}
    velocity::Vector{Int}
end

function fromline(line::AbstractString)
    m = match(ROBOT_RE, line)
    position = parse.(Int, m.captures[1:2])
    velocity = parse.(Int, m.captures[3:4])
    return Robot(position, velocity)
end

function move!(robot::Robot)
    newposition = robot.position + robot.velocity
    newposition[1] = mod(newposition[1], WIDTH)
    newposition[2] = mod(newposition[2], HEIGHT)
    return robot.position = newposition
end


function isinfirstquadrant(robot::Robot)
    width = WIDTH ÷ 2
    height = HEIGHT ÷ 2
    return robot.position[1] > width && robot.position[2] < height
end

function isinsecondquadrant(robot::Robot)
    width = WIDTH ÷ 2
    height = HEIGHT ÷ 2
    return robot.position[1] < width && robot.position[2] < height
end

function isinthirdquadrant(robot::Robot)
    width = WIDTH ÷ 2
    height = HEIGHT ÷ 2
    return robot.position[1] < width && robot.position[2] > height
end

function isinfourthquadrant(robot::Robot)
    width = WIDTH ÷ 2
    height = HEIGHT ÷ 2
    return robot.position[1] > width && robot.position[2] > height
end

function part1()
    lines = open("input/day14.txt") do f
        return readlines(f)
    end

    robots = fromline.(lines)
    for _ in 1:100
        move!.(robots)
    end

    return count(isinfirstquadrant, robots) *
           count(isinsecondquadrant, robots) *
           count(isinthirdquadrant, robots) *
           count(isinfourthquadrant, robots)
end

function part2()
    lines = open("input/day14.txt") do f
        return readlines(f)
    end

    robots = fromline.(lines)
    for i in 1:WIDTH*HEIGHT
        move!.(robots)
        img = ones(HEIGHT, WIDTH)
        for robot in robots
            img[robot.position[2]+1, robot.position[1]+1] = 0
        end
        save("output/$i.bmp", img)
    end
end
