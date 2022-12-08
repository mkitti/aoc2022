module Day02
    export read_input, part1
    """
    Appreciative of your help yesterday, one Elf gives you an encrypted strategy guide (your puzzle input) that they say will be sure to help you win. "The first column is what your opponent is going to play: A for Rock, B for Paper, and C for Scissors. The second column--" Suddenly, the Elf is called away to help with someone's tent.

The second column, you reason, must be what you should play in response: X for Rock, Y for Paper, and Z for Scissors. Winning every time would be suspicious, so the responses must have been carefully chosen.

The winner of the whole tournament is the player with the highest score. Your total score is the sum of your scores for each round. The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).
"""
    function read_input(file::String = "input.txt")
        pairs = Pair{Char,Char}[]
        for line in eachline(file)
            push!(pairs, line[1] => line[3])
        end
        return pairs
    end

    const score_matrix = [
        3 6 0
        0 3 6
        6 0 3
    ]

    function part1(input = read_input())
        score = 0
        for p in input
            them = first(p) - 'A' + 1
            us = last(p) - 'X' + 1
            # A , X = Paper
            # B,  y = Rock
            # C,  Z = Scissors
            score += score_matrix[them,us]
            println(score_matrix[them, us])
            println(us)
            score += us
        end
        score
    end

    """
    X means to lose
    Y means to draw
    Z means to win
    """
    function part2(input = read_input())
        score = 0
        for p in input
            them = first(p) - 'A' + 1
            outcome = last(p) - 'X'
            outcome *= 3
            us = findfirst(==(outcome), score_matrix[them,:])
            score += us + outcome
        end
        return score
    end
end