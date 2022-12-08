module Day04

export read_input, part1, part2

function read_input(file = "input.txt")
    assignment_pairs = Tuple{UnitRange{Int},UnitRange{Int}}[]
    for line in eachline(file)
        s = split(line, ",")
        s1 = split(s[1], "-")
        s2 = split(s[2], "-")
        a = parse(Int, s1[1])
        b = parse(Int, s1[2])
        c = parse(Int, s2[1])
        d = parse(Int, s2[2])
        push!(assignment_pairs, (a:b, c:d))
    end
    return assignment_pairs
end

function part1(input = read_input())
    contained = 0
    for assignment in input
        if intersect(assignment...) ∈ assignment
            contained += 1
        end
    end
    return contained
end

function part2(input = read_input())
    overlap_at_all = 0
    for assignment in input
        if !isempty(intersect(assignment...))
            overlap_at_all += 1
        end
    end
    return overlap_at_all
end


end # module Day04
