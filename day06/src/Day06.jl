module Day06
    export read_inputs, part1, part2, main

function read_inputs()
    return [readlines("examples.txt"); readlines("input.txt")]
end

function part1(str)
    for i in 4:length(str)
        s = @view(str[i-3:i])
        if allunique(s)
            return i
        end
    end
end

function part2(str)
    for i in 14:length(str)
        s = @view(str[i-13:i])
        if allunique(s)
            return i
        end
    end
end

function main()
    lines = read_inputs()
    @info "Part 1" part1.(lines)
    @info "Part 2" part2.(lines)
end

end # module Day06
