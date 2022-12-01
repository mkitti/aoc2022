use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn read_input(path: &Path) -> Vec<Vec<i64>> {
    let display = path.display();
    let file = match File::open(&path) {
        Err(why) => panic!("could not open {}: {}", display, why),
        Ok(file) => file
    };
    let buf = io::BufReader::new(file);
    let mut elves : Vec<Vec<i64>> = Vec::new();
    let mut current_elf : Vec<i64> = Vec::new();
    for line in buf.lines() {
        if let Ok(line) = line {
            if !line.is_empty() {
                let num: i64 = line.parse().unwrap();
                current_elf.push(num);
            } else {
                elves.push(current_elf);
                current_elf = Vec::new();
            }
        }
    }
    elves.push(current_elf);
    elves
}

fn get_total(elves: &Vec<Vec<i64>>) -> Vec<i64> {
    let mut elves_total : Vec<i64> = Vec::with_capacity(elves.len());
    for elf in elves {
        let total : i64 = elf.iter().sum();
        elves_total.push(total);
    }
    elves_total.sort_unstable();
    elves_total.reverse();
    elves_total
}

fn main() {
    let path = Path::new("input.txt");
    let elves = read_input(&path);

    let elves_total = get_total(&elves);
    println!("Max value: {}", elves_total[0]);

    let top_three_total : i64 = (&elves_total[0..3]).iter().sum();
    println!("Top three sum: {}", top_three_total);
}
