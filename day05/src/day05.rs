use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use regex::Regex;


struct Move {
    number: i64,
    orig: usize,
    dest: usize 
}

fn read_input(path: &Path) -> (Vec<Vec<char>>, Vec<Move>) {
    let display = path.display();
    let file = match File::open(&path) {
        Err(why) => panic!("could not open {}: {}", display, why),
        Ok(file) => file
    };
    let buf = io::BufReader::new(file);
    let lines = buf.lines();
    let mut nstacks = 0;
    let mut stacks = Vec::new();
    let mut stacks_loaded = false;
    let pattern = Regex::new(r"move (\d*) from (\d*) to (\d*)").unwrap();
    let mut moves = Vec::new();
    for line in lines {
        if let Ok(line) = line {
            if !stacks_loaded {
                if nstacks == 0 {
                    nstacks = (line.len() + 1) / 4;
                    for _n in 0..nstacks {
                        stacks.push(Vec::new());
                    }
                }
                let chars : Vec<char> = line.chars().collect();
                if line.is_empty() {
                    //Remove number
                    stacks.iter_mut().for_each(|s| { s.pop(); });
                    stacks_loaded = true;
                } else {
                    for n in 0..nstacks {
                        let c = chars[n*4+1];
                        if c != ' ' {
                            stacks[n].push(c);
                        }
                    }
                }
            } else {
                println!("{}", line);
                let cap = pattern.captures(&line).unwrap();
                let m = Move {
                    number: cap.get(1).unwrap().as_str().parse().unwrap(),
                    orig: cap.get(2).unwrap().as_str().parse().unwrap(),
                    dest: cap.get(3).unwrap().as_str().parse().unwrap()
                };
                moves.push(m);
            }
        }
    }
    return (stacks, moves);
}

fn part1(mut stacks : Vec<Vec<char>>, moves: Vec<Move>) {
    println!("{}", stacks.len());
    for m in moves {
        for _n in 0..m.number {
            let c = stacks[m.orig].pop().unwrap();
            stacks[m.dest-1].insert(0, c);
        }
    }
    for stack in stacks {
        println!("{}", stack[0]);
    }
}

fn main() {
    //let path = Path::new("input.txt");
    let path = Path::new("example.txt");
    let (stacks, moves) = read_input(&path);
    part1(stacks, moves);
    println!("{}", "Hello World");
}