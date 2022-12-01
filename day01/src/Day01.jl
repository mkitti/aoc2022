module Day01

export read_input

function read_input(file = "input.txt")
    elves = Vector{Int}[]
    current_elf = Int[]
    for line in eachline(file)
        if isempty(line)
            push!(elves, current_elf)
            current_elf = Int[]
        else
            push!(current_elf, parse(Int, line))
        end
    end
    push!(elves, current_elf)
    return elves
end

#70369
part1(input = read_input()) = maximum(sum.(input))

#203002
part2(input = read_input()) = sum(sort(sum.(input))[end-2:end])

function solve(file = "input.txt")
    input = read_input(file)
    println(part1(input))
    println(part2(input))
end

__init__() = solve()

end