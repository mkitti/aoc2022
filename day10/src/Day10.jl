module Day10

using OffsetArrays

export read_input, part1, part2

@enum Ops begin
    noop
    addx
end


# input_file() = "example.txt"
input_file() = "input.txt"

function read_input(file = input_file())
    instructions = Tuple{Ops, Int}[]
    for line in eachline(file)
        if startswith(line, "addx")
            push!(instructions, (addx, parse(Int, line[6:end])))
        else
            push!(instructions, (noop, 0))
        end
    end
    return instructions
end

function part1(input = read_input())
    cycle = 1
    X = 1
    running = 0
    op = noop
    arg = 0
    signal_strengths = Int[]
    while !isempty(input)
        # @info "Cycle" cycle X
        if running == 0
            if op == addx
                X += arg
            end
            op, arg = popfirst!(input)
            if op == noop
            elseif op == addx
                running = 1
            else
                error("Unknown op")
            end
        else
            running -= 1
        end
        if cycle % 20 == 0
            push!(signal_strengths, cycle * X)
        end
        cycle += 1
    end
    return sum(signal_strengths[1:2:12])
end

# ERCREPCJ
function part2(input = read_input())
    cycle = 1
    X = 1
    running = 0
    op = noop
    arg = 0
    screen = falses(40, 6)
    while !isempty(input)
        # @info "Cycle" cycle X
        if running == 0
            if op == addx
                X += arg
            end
            op, arg = popfirst!(input)
            if op == noop
            elseif op == addx
                running = 1
            else
                error("Unknown op")
            end
        else
            running -= 1
        end
        screen[cycle] = (X + 1) == cycle % 40 || X == cycle % 40 || (X + 2) == cycle % 40
        cycle += 1
    end
    f(x) = x ? '#' : '.'
    # \:white_large_square ⬜
    # \:black_large_square ⬛
    g(x) = x ? '⬜' : '⬛'
    for i in 1:6
        println(String(g.(screen[:,i])))
    end
    return permutedims(screen, (2,1))
end

end # module Day10
 