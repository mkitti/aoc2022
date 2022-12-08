module Day03
    export read_input, part1, part2
    #input_file = "example.txt"
    input_file = "input.txt"
    function read_input(file = input_file)
        open(file) do io
            readlines(io)
        end
    end
    function part1(input = read_input())
        score = 0
        for line in input
            clength = length(line) ÷ 2
            x = Set(line[1:clength])
            y = Set(line[clength+1:end])
            overlap = pop!(intersect(x,y))
            score += p1score(overlap)
        end
        return score
    end
    function p1score(letter)
        lowercase(letter) - 'a' + 1 + isuppercase(letter)*26
    end
    function part2(input = read_input())
        score = 0
        for group in Iterators.partition(input, 3)
            overlap = intersect(group...) |> first
            score += p1score(overlap)
        end
        return score
    end
end