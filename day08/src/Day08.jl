module Day08

using ImageFiltering

export read_input, part1, part2

# input_file() = "example.txt"
input_file() = "input.txt"

function read_input(file = input_file())
    lines = readlines(file)
    return permutedims(Int8.(hcat(collect.(lines)...) .- '0'), (2,1))
end

const kernel = [0 1 0; 1 1 1; 0 1 0]

# 1533
function part1(input = read_input())
    padded = padarray(input, Fill(-1,(1,1)))
    down = accumulate(max, padded[0:end-2, 1:end-1]; dims = 1, init=-1)
    left = accumulate(max, padded[1:end-1, 0:end-2]; dims = 2, init=-1)
    rev_padded = reverse(padded)
    up = reverse(accumulate(max, rev_padded[0:end-2, 1:end-1]; dims = 1, init=-1))
    right= reverse(accumulate(max, rev_padded[1:end-1, 0:end-2]; dims = 2, init=-1))
    min_coverage = minimum(cat(down, left, up, right; dims=3); dims=3)
    visible = input .> min_coverage
    return sum(visible)
end

# 345744
function part2(input = read_input())
    r, c = size(input)
    @assert r == c
    s = r
    padded = padarray(input, Fill(10,(r,c)))
    up_trees = fill!(similar(input), -1)
    left_trees = fill!(similar(input), -1)
    down_trees = fill!(similar(input), -1)
    right_trees = fill!(similar(input), -1)
    for shift in 1:s
        up_shift = padded[-shift+1:s-shift, 1:s]
        left_shift = padded[1:s, -shift+1:s-shift]
        down_shift = padded[1+shift:s+shift, 1:s]
        right_shift = padded[1:s, 1+shift:s+shift]

        for (trees, dshift) in zip((up_trees, left_trees, down_trees, right_trees), (up_shift, left_shift, down_shift, right_shift))
            trees[(trees .== -1) .& (input .<= dshift) .& (dshift .!= 10)] .= shift
            trees[(trees .== -1) .& (input .<= dshift) .& (dshift .== 10)] .= shift-1
        end
        #=
        up_trees[(up_trees .== 0) .& (input .<= up_shift) .& (up_shift .!= 10)] .= shift
        up_trees[(up_trees .== 0) .& (input .<= up_shift) .& (up_shift .== 10)] .= shift-1
        left_trees[(left_trees .== 0) .& (input .<= left_shift)] .= shift
        down_trees[(down_trees .== 0) .& (input .<= down_shift)] .= shift
        right_trees[(right_trees .== 0) .& (input .<= right_shift)] .= shift
        =#

        @info "up" shift up_shift
    end
    maximum(Int64.(up_trees) .* left_trees .* down_trees .* right_trees)
    # up_trees, left_trees, down_trees, right_trees
end

end # module Day08
