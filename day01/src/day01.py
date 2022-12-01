def read_input(file):
    elves = []
    current_elf = []
    with open(file, "r") as f:
        for line in f:
            line = line[:-1]
            if line:
                current_elf.append(int(line))
            else:
                elves.append(current_elf)
                current_elf = []
        elves.append(current_elf)
    return elves

def part1(input):
    totals = [sum(elf) for elf in input]
    return max(totals)

def part2(input):
    totals = [sum(elf) for elf in input]
    totals.sort()
    return sum(totals[-3:])

input = read_input("input.txt")
print(part1(input))
print(part2(input))
