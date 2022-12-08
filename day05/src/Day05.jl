module Day05

export read_input, part1, part2, Move

struct Move
    number::Int
    orig::Int
    dest::Int
end

function read_input(file = "input.txt")
    lines = eachline(file; keep = true)
    stacks = nothing
    nstacks = 0
    stacks_loaded = false
    moves = Move[]
    pattern = r"move (\d*) from (\d*) to (\d*)"
    for line in lines
        if !stacks_loaded
            if isempty(line) || line == "\n"
                # Remove numbers
                pop!.(stacks)
                stacks_loaded = true
            else
                if isnothing(stacks)
                    nstacks = length(line) ÷ 4
                    stacks = [Char[] for i in 1:nstacks]
                end
                for s in 1:nstacks
                    c = line[(s-1)*4 + 2]
                    if c != ' '
                        push!(stacks[s], c)
                    end
                end
            end
        else
            # push!(moves, line)
            m = match(pattern, line)
            push!(moves, Move(parse.(Int, m.captures)...))
        end
    end
    stacks, moves
end

function part1(input = read_input())
    stacks, moves = input
    for move in moves
        for n in 1:move.number
            c = popfirst!(stacks[move.orig])
            pushfirst!(stacks[move.dest], c)
        end
    end
    return String(first.(stacks))
end

function part2(input = read_input())
    stacks, moves = input
    for move in moves
        c = splice!(stacks[move.orig], 1:move.number)
        stacks[move.dest] = [c; stacks[move.dest]]
    end
    return String(first.(stacks))
end

end # module Day05
