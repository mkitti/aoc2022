module Day12

using PaddedViews, OffsetArrays

export read_input, part1, part2

# input_file() = "example.txt"
input_file() = "input.txt"

function read_input(file = input_file())
    lines = readlines(file)
    matrix =  hcat(Vector{Char}.(lines)...)
    return permutedims(matrix, (2,1))
end


function old_part1(input = read_input())
    start = findfirst(==('S'), input)
    sz = size(input)
    padded_map = PaddedView('z'+2, input, (0:sz[1]+1,0:sz[2]+1))
    paths = climb(padded_map, start)
    return minimum(length.(paths))
end

const p1_moves = [
    CartesianIndex(-1,  0),
    CartesianIndex( 0, -1),
    CartesianIndex( 1,  0),
    CartesianIndex( 0,  1),
]

function climb(
    padded_map::AbstractMatrix,
    position::CartesianIndex{2},
) where N
    current_level = padded_map[position]
    if current_level == 'S'
        current_level = 'a'
    end
    max_level = current_level + 1
    @info "Position" position current_level
    candidate_cis = map(p1_moves) do m
        position + m
    end
    candidates = padded_map[candidate_cis]
    updated_map = copy(padded_map)
    updated_map[position] = '|'
    if 'z' <= max_level
        Enear = findfirst(==('E'), candidates)
        if !isnothing(Enear)
            display(updated_map)
            return [[p1_moves[Enear] + position]]
        end
    end
    cis = p1_moves[findall(<=(max_level), candidates)]
    paths = Vector{CartesianIndex{2}}[]
    for ci in cis
        next_position = ci + position
        result = climb(updated_map, next_position)
        if !isempty(result)
            pushfirst!.(result, Ref(next_position))
            append!(paths, result)
        end
    end
    return paths
end

using ImageMorphology, ImageInTerminal, ColorTypes

function part1_astar(input = read_input())
    map = input .- 'a'
    origin = findfirst(==('S'), input)
    goal = findfirst(==('E'), input)
    map[origin] = -1
    map[goal] = 25
    # return map
    current = -1
    start = map .== current
    total_steps = 0
    total_path = falses(size(map))
    total_total = zeros(Int, size(input))
    for current in -1:25
        next = current + 1
        mask = (map .== next) .| (map .== current)
        if current < 25
            finish = map .== next
        else
            finish = falses(size(map))
            finish[goal] = true
        end
        from = distmap(start, mask)
        to = distmap(finish, mask)
        total = from .+ to
        if current == -1
            total_total = total
        else
            total_total += total
        end
        fewest_steps = minimum(total[finish])
        path = total .== fewest_steps
        total_path = total_path .| path
        display(Gray.(total_path))
        start = path .& finish
        display(Gray.(start))
        total_steps += fewest_steps
        @info "status" current fewest_steps total_steps
    end
    return total_total
end

const plus_se = strel(centered(Bool[0 1 0; 1 0 1; 0 1 0]))

function distmap(seed, mask)
    map = zeros(Int, size(seed))
    work = seed
    map .+= work
    sum_work = 0
    prev_sum_work = -1
    while !isnothing(findfirst(==(0), map[mask]))
        work = dilate(work, plus_se) .& mask
        sum_work = sum(work)
        if sum_work == prev_sum_work
            break
        end
        map .+= work
        prev_sum_work = sum_work
    end
    return maximum(map) .- map
end

# From Gunnar Farnebäck
# Reference https://julialang.zulipchat.com/#narrow/stream/357314-advent-of-code-spoilers-.282022.29/topic/day.2012/near/315351402
function part1_gf(input = (; data = read(input_file())))
    h = copy(input.data)
    N = findfirst(==(UInt8('\n')), h)
    s = findfirst(==(UInt8('S')), h)
    d = fill(typemax(Int), length(h))
    d[s] = 0
    h[s] = UInt8('a')
    queue = [s]
    while !isempty(queue)
        p = popfirst!(queue)
        for n in (p - N, p - 1, p + 1, p + N)
            n < 1 && continue
            n > length(h) && continue
            d[n] < typemax(Int) && continue
            h[n] == UInt8('\n') && continue
            if h[n] == UInt8('E')
                h[p] >= UInt8('y') && return d[p] + 1
                continue
            end
            h[n] > h[p] + 1 && continue
            d[n] = d[p] + 1
            push!(queue, n)
        end
    end
    @assert false
end

function part1(input = read_input())
    map = Int8.(input .- 'a')
    origin = findfirst(==('S'), input)
    goal = findfirst(==('E'), input)
    map[origin] = 0
    map[goal] = 'z' - 'a' + 1
    sz = size(input)
    padded_map = PaddedView(typemax(eltype(map)), map, (0:sz[1]+1,0:sz[2]+1))
    iterative_search(padded_map, origin, map[goal], v->v >= 'y' - 'a')
end

# based on part1_gf above
function iterative_search(map::M, origin::CartesianIndex{2}, goal::T, condition::Function, ascending::Bool = true) where {T, M <: AbstractMatrix{T}}
    position_queue = CartesianIndex{2}[origin]
    D = Int
    distance = fill!(similar(map, D), typemax(D))
    distance[origin] = 0
    while !isempty(position_queue)
        p = popfirst!(position_queue)
        # println(p)
        for n in ntuple(i->p+p1_moves[i], length(p1_moves))
            # println(n)
            if map[n] == goal
                if condition(map[p])
                    return distance[p] + 1
                else
                    continue
                end
            end
            # @info "status" n map[n] map[p]
            map[n] == typemax(T) && continue
            if ascending
                map[n] > map[p] + 1 && continue
            else
                map[n] < map[p] - 1 && continue
            end
            distance[n] < typemax(D) && continue
            distance[n] = distance[p] + 1
            push!(position_queue, n)
        end
    end
    @assert false
end

function part2(input = read_input())
    map = Int8.(input .- 'a')
    origin = findfirst(==('S'), input)
    goal = findfirst(==('E'), input)
    map[origin] = 0
    map[goal] = 'z' - 'a' + 1
    sz = size(input)
    padded_map = PaddedView(typemax(eltype(map)), map, (0:sz[1]+1,0:sz[2]+1))
    iterative_search(padded_map, goal, Int8(0), v->v <= 1, false)
end

end # module Day12
