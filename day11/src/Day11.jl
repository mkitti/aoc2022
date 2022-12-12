module Day11

export read_input, part1, part2

struct Monkey{I}
    id::Int
    items::Vector{I}
    operation::Function
    action::Function
    count::Base.RefValue{Int}
    divisible_by::Int
end
Monkey(args...) = Monkey{Int}(args...)

# input_file() = "example.txt"
input_file() = "input.txt"

function read_monkey(io)
    line = readline(io)
    m = match(r"Monkey (\d*):", line)
    @assert !isnothing(m)
    id = parse(Int, m.captures[1])

    line = readline(io)
    m = match(r"Starting items: (.*)", line)
    @assert !isnothing(m)
    items_string = split(m.captures[1], ",")
    items = parse.(Int, items_string)

    line = readline(io)
    m = match(r"Operation: (.*)", line)
    @assert !isnothing(m)
    e = quote
        old->$(Meta.parse(m.captures[1]))
    end
    operation = eval(e)

    line = readline(io)
    m = match(r"Test: divisible by (\d*)", line)
    @assert !isnothing(m)
    divisible_by = parse(Int, m.captures[1])

    line = readline(io)
    m = match(r"If true: throw to monkey (\d*)", line)
    @assert !isnothing(m)
    true_monkey = parse(Int, m.captures[1])

    line = readline(io)
    m = match(r"If false: throw to monkey (\d*)", line)
    @assert !isnothing(m)
    false_monkey = parse(Int, m.captures[1])

    action = worry -> worry % divisible_by == 0 ? true_monkey : false_monkey

    line = readline(io)
    @assert isempty(line)

    return Monkey(
        id,
        items,
        operation,
        action,
        Ref(0),
        divisible_by
    )
end

function read_input(file = input_file())
    monkeys = Dict{Int, Monkey}()
    open(file) do f
        while !eof(f)
            try
                monkey = read_monkey(f)
                monkeys[monkey.id] = monkey
            catch e
                @warn e
                @info position(f)
            end
        end
    end
    return monkeys
end

function part1(monkeys = read_input())
    n = length(monkeys)
    for round in 1:20
        for id in 0:n-1
            monkey = monkeys[id]
            for _ in 1:length(monkey.items)
                monkey.count[] += 1
                item = popfirst!(monkey.items)
                postop = Base.invokelatest(monkey.operation, item)
                pretest = div(postop, 3, RoundDown)
                target = Base.invokelatest(monkey.action, pretest)
                push!(monkeys[target].items, pretest)
            end
        end
    end
    top_two = sort([monkey.count[] for monkey in values(monkeys)])[end-1:end]
    return prod(top_two)
end

function part2(monkeys = read_input(); nrounds=10000)
    n = length(monkeys)
    divisors = [monkey.divisible_by for monkey in values(monkeys)]
    factor = prod(divisors)
    for round in 1:nrounds
        for id in 0:n-1
            monkey = monkeys[id]
            for _ in 1:length(monkey.items)
                monkey.count[] += 1
                item = popfirst!(monkey.items)
                postop = Base.invokelatest(monkey.operation, item)
                pretest = postop % factor
                target = Base.invokelatest(monkey.action, pretest)
                push!(monkeys[target].items, pretest)
            end
        end
    end
    monkey_counts = [monkey.count[] for monkey in values(monkeys)]
    top_two = sort(monkey_counts)[end-1:end]
    return prod(top_two)
end

end # module Day11
