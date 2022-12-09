module Day09

export read_input, part1, part2

#input_file() = "example.txt"
input_file() = "input.txt"

function read_input(file = input_file())
    dir = 'A'
    instructions = Tuple{Char,Int}[]
    open(file) do f
        for line in eachline(f)
            m = match(r"(\D) (\d*)", line)
            push!(instructions, (m.captures[1][1], parse(Int,m.captures[2])))
        end
    end
    return instructions
end

const dirdict = Dict('R' => (0,1), 'U' => (-1,0), 'L' => (0,-1), 'D' => (1,0))

# 6376
function part1(input = read_input())
    head = (1,1)
    tail = (1,1)
    tail_positions = Tuple{Int,Int}[]
    for (dir, num) in input
        for i in 1:num
            head = head .+ dirdict[dir]
            delta = head .- tail
            if maximum(abs.(delta)) > 1
                tail = tail .+ sign.(delta)
            end
            push!(tail_positions, tail)
            # @info "position" head tail
        end
    end
    return length(unique(tail_positions))
end

#2607
function part2(input = read_input())
    head = (1,1)
    knots = [(1,1) for k in 1:9]
    tail_positions = Tuple{Int,Int}[]
    for (dir, num) in input
        for i in 1:num
            head = head .+ dirdict[dir]
            delta = head .- first(knots)
            for k in 1:9
                if maximum(abs.(delta)) > 1
                    knots[k] = knots[k] .+ sign.(delta)
                end
                if k < 9
                    delta = knots[k] .- knots[k+1]
                end
            end
            push!(tail_positions, knots[end])
            # @info "position" head tail
        end
    end
    return length(unique(tail_positions))
end

end # module Day09
