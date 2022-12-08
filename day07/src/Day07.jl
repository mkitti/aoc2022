module Day07

export read_input, part1, part2, total_size

#input_file() = "example.txt"
input_file() = "input.txt"

const pattern = r"(\d+) (.*)"

function read_input(input = input_file())
    dirdict = Dict{String, Dict{String, Int}}()
    childdirs = Dict{String, Vector{String}}()
    open(input, "r") do f
        first_line = readline(f)
        @assert first_line == "\$ cd /"
        path = "/"
        childdirs["/"] = String[]
        listing = false
        for line in eachline(f)
            if startswith(line, "\$ cd ")
                newpath = line[6:end]
                if newpath == "/"
                    path = "/"
                else
                    path = abspath(joinpath(path, newpath))
                end
                childdirs[path] = get(childdirs, path, String[])
                dirdict[path] = get(dirdict, path, Dict{String,Int}())
                listing = false
            elseif startswith(line, "\$ ls")
                listing = true
            elseif startswith(line, "dir ")
                childdirs[path] = get(childdirs, path, String[])
                subdir = abspath(joinpath(path, line[5:end]))
                push!(childdirs[path], subdir)
                childdirs[subdir] = get(childdirs, subdir, String[])
            elseif listing
                m = match(pattern, line)
                if isnothing(m)
                    error("Could not parse $line")
                end
                dirdict[path] = get(dirdict, path, Dict{String,Int}())
                dirdict[path][m.captures[2]] = parse(Int, m.captures[1])
            end
        end
    end
    return dirdict, childdirs
end

function part1(input = read_input())
    total_size_dict = get_total_size_dict(input)
    return sum(filter(<=(100_000), collect(values(total_size_dict))))
end

function get_total_size_dict(input = read_input())
    d, c = input
    dir_sizes =  sum.(values.(values(d)))
    sizedict = Dict(keys(d) .=> dir_sizes)
    total_size_dict = Dict{String, Int}()
    #return sizedict
    for dir in keys(d)
        total_size_dict[dir] = total_size(dir, sizedict, c)
    end
    return total_size_dict
end


function total_size(path, sizedict, c)
    total = sizedict[path]
    for subdir in c[path]
        total += total_size(subdir, sizedict, c)
    end
    return total
end

function part2(input = read_input())
    total_drive_size = 70_000_000
    required_space = 30_000_000
    total_size_dict = get_total_size_dict(input)
    free_space = total_drive_size - total_size_dict["/"]
    space_to_free = required_space - free_space
    return minimum(filter(>=(space_to_free), collect(values(total_size_dict))))
end

end # module Day07
